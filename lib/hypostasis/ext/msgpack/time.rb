class Time
  def self.to_msgpack_type(value)
    value.to_i
  end

  def self.from_msgpack_type(value)
    Time.at(value.to_i)
  end
end
