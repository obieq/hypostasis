class DateTime
  def self.to_msgpack_type(value)
    value.to_s
  end

  def self.from_msgpack_type(value)
    DateTime.parse(value.to_s)
  end
end
