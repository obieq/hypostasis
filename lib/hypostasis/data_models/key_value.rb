require 'date'

module Hypostasis::DataModels::KeyValue
  #include Hypostasis::DataModels::Utilities

  def set(key, value, klass = nil)
    value = klass.to_msgpack_type(value) unless klass.nil?
    database.set("#{name}\\#{key.to_s}", value.to_msgpack)
  end

  def get(key, klass = nil)
    value = database.get("#{name}\\#{key.to_s}")
    raise Hypostasis::Errors::KeyNotFound if value.nil?
    begin
      value = MessagePack.unpack StringIO.new(value)
      value = klass.from_msgpack_type(value) unless klass.nil?
    rescue StandardError
      raise Hypostasis::Errors::UnknownValueType
    end
    value
  end
end
