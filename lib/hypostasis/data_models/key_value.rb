require 'date'

module Hypostasis::DataModels::KeyValue
  include Hypostasis::DataModels::Utilities

  def set(key, value)
    database.set(key_path_for(key.to_s), serialize_messagepack(value))
  end

  def get(key, klass = nil)
    raw_value = database.get(key_path_for(key.to_s))
    raise Hypostasis::Errors::KeyNotFound if raw_value.nil?
    deserialize_messagepack raw_value, klass
  end
end
