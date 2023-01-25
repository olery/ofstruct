class LStruct < ::Hash

  class Array < ::Array; end

  def self.new hash=nil, default=nil, &block
    return super default unless hash or block
    return super &block unless hash
    self[hash].tap{ |h| h.default = default }
  end

  alias _regular_reader []
  alias _regular_writer []=

  def [](key)
    __get key
  end
  def []=(key,value)
    __get key,value
  end

  private

  def method_missing name, *args
    return __get name[0..-2].to_sym, args.first if name[-1] == '='
    __get(name) || __get(name.to_s)
  end

  def __get key, value = _regular_reader(key)
    return if !value and !key? key # don't write nil
    _regular_writer key, __convert(value)
  end

  def __convert value
    if value.class == ::Hash
      self.class.new value
    elsif value.class == ::Array
      Array.new value.map{ |v| __convert v }
    else
      value
    end
  end

end
