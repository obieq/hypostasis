require 'date'

module Hypostasis::DataModels::KeyValue
  include Hypostasis::DataModels::Utilities

  def set(key, value)
    database.set("#{name}\\#{key.to_s}", serialize_messagepack(value))
  end

  def get(key, klass = nil)
    raw_value = database.get("#{name}\\#{key.to_s}")
    raise Hypostasis::Errors::KeyNotFound if raw_value.nil?
    begin
      deserialize_messagepack MessagePack.unpack(StringIO.new(raw_value)), klass
    rescue StandardError
      raise Hypostasis::Errors::UnknownValueType
    end
  end
end
