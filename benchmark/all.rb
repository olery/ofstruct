require "benchmark/ips"
require "benchmark-memory"
require 'active_support/all'
require 'hashie'
require_relative "../lib/ofstruct"
require_relative "../lib/lstruct"

$hash = {
  name:     'John',
  children: [
    {name: 'Foo'},
    {name: 'Bar'},
  ],
}

class PORO
  attr_accessor :name, :surname, :children

  def initialize attrs={}
    attrs.each do |attr, value|
      instance_variable_set "@#{attr}", value
    end
  end
end
PersonStruct = Struct.new :name, :surname, :children, keyword_init: true
PersonData   = Data.new :name, :surname, :children if RUBY_VERSION >= '3.2.0'

bench = -> x do
  x.report "Hash" do
    object = Hash[$hash]
    object[:name]
    object[:surname] = "Smith"
    object[:surname]
    object[:children].first[:name]
  end

  x.report "HashWithIndifferentAccess" do
    object = HashWithIndifferentAccess[$hash]
    object[:name]
    object[:surname] = "Smith"
    object[:surname]
    object[:children].first[:name]
  end

  x.report "OpenFastStruct" do
    object = OpenFastStruct.new $hash
    object.name
    object.surname = "Smith"
    object.surname
    object.children.first.name
  end

  x.report "LStruct" do
    object = LStruct.new $hash
    object.name
    object.surname = "Smith"
    object.surname
    object.children.first.name
  end

  x.report "Hashie" do
    object = Hashie::Mash.new $hash
    object.name
    object.surname = "Smith"
    object.surname
    object.children.first.name
  end

  x.report "OpenStruct" do
    object = OpenStruct.new $hash
    object.name
    object.surname = "Smith"
    object.surname
    object.children.first[:name]
  end

  x.report "PORO" do
    object = PORO.new $hash
    object.name
    object.surname = "Smith"
    object.surname
    object.children.first[:name]
  end

  x.report "Struct" do
    object = PersonStruct.new **$hash
    object.name
    object.surname = "Smith"
    object.surname
    object.children.first[:name]
  end

  x.report "Data" do
    object = PersonData.new **$hash
    object.name
    object.surname = "Smith"
    object.surname
    object.children.first[:name]
  end if RUBY_VERSION >= '3.2.0'

  x.compare!
end

Benchmark.ips(&bench)
Benchmark.memory(&bench)
