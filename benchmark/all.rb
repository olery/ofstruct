require "benchmark/ips"
require "benchmark-memory"
require 'active_support/all'
require 'hashie'
require 'recursive_open_struct'
require_relative "../lib/ofstruct"
require_relative "../lib/lstruct"

$hash = JSON.parse File.read 'test.json'
$keys = $hash.keys

class PORO
  $keys.each do |k|
    attr_accessor k
  end

  def initialize attrs={}
    attrs.each do |attr, value|
      instance_variable_set "@#{attr}", value
    end
  end
end
PersonStruct = Struct.new :id, :superlative, :locale, :title, :brandType, :reviewScoreWithDescription, :text, :stayDuration, :submissionTime, :themes, :reviewInteractionSections, :__typename, :reviewAuthorAttribution, :photos, :travelers, :translationInfo, :propertyReviewSource, :managementResponses, keyword_init: true
PersonData   = Data.new *$keys if RUBY_VERSION >= '3.2.0'

bench = -> x do
  x.report "Hash" do
    object = Hash[$hash]
    object['id']
    object['text'] = "Smith"
    object['submissionTime']['longDateFormat']
    object['themes'].first['icon']
  end

  x.report "HashWithIndifferentAccess" do
    object = HashWithIndifferentAccess[$hash]
    object[:id]
    object[:text] = "Smith"
    object[:submissionTime][:longDateFormat]
    object[:themes].first[:icon]
  end

  x.report "OpenFastStruct" do
    object = OpenFastStruct.new $hash
    object.id
    object.text = "Smith"
    object.submissionTime.longDateFormat
    object.themes.first.icon
  end

  x.report "LStruct" do
    object = LStruct.new $hash
    object.id
    object.text = "Smith"
    object.submissionTime.longDateFormat
    object.themes.first.icon
  end

  x.report "Hashie" do
    object = Hashie::Mash.new $hash
    object.id
    object.text = "Smith"
    object.submissionTime.longDateFormat
    object.themes.first.icon
  end

  x.report "RecursiveOpenStruct" do
    object = RecursiveOpenStruct.new $hash, recurse_over_arrays: true
    object.id
    object.text = "Smith"
    object.submissionTime.longDateFormat
    object.themes.first.icon
  end

  x.report "OpenStruct" do
    object = OpenStruct.new $hash
    object.id
    object.text = "Smith"
    object.submissionTime['longDateFormat']
    object.themes.first[:icon]
  end

  x.report "PORO" do
    object = PORO.new $hash
    object.id
    object.text = "Smith"
    object.submissionTime['longDateFormat']
    object.themes.first[:icon]
  end

  x.report "Struct" do
    object = PersonStruct.new **$hash
    object.id
    object.text = "Smith"
    object.submissionTime['longDateFormat']
    object.themes.first[:icon]
  end

  x.report "Data" do
    object = PersonData.new **$hash
    object.id
    object.text = "Smith"
    object.submissionTime['longDateFormat']
    object.themes.first[:icon]
  end if RUBY_VERSION >= '3.2.0'

  x.compare!
end

Benchmark.ips(&bench)
Benchmark.memory(&bench)
