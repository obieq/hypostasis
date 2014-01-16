class Hypostasis::Tuple
  def initialize(*tuple)
    @tuple = tuple.to_a.flatten
    raise Hypostasis::Errors::InvalidTuple if @tuple.empty?
    self
  end

  def to_a
    @tuple
  end

  def to_s
    @tuple_str ||= FDB::Tuple.pack(@tuple)
  end

  def prepend(*prefix)
    return self if prefix.empty?
    prepended_tuple = prefix.to_a + @tuple
    Hypostasis::Tuple.new(prepended_tuple)
  end

  def append(*extension)
    return self if extension.empty?
    appended_tuple = @tuple + extension.to_a
    Hypostasis::Tuple.new(appended_tuple)
  end

  def trim(count = 0)
    count = count.to_i
    raise Hypostasis::Errors::TupleExhausted if count.abs > @tuple.size - 1
    trimmed_tuple = @tuple
    if count > 0
      trimmed_tuple.pop(count.abs)
      Hypostasis::Tuple.new(trimmed_tuple)
    elsif count < 0
      trimmed_tuple.shift(count.abs)
      Hypostasis::Tuple.new(trimmed_tuple)
    else
      self
    end
  end

  def self.unpack(tuple_string)
    Hypostasis::Tuple.new(FDB::Tuple.unpack(tuple_string))
  end
end
