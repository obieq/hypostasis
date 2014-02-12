require 'date'

module Hypostasis::DataModels::KeyValue
  include Hypostasis::DataModels::Utilities

  def set(key, value)
    database.transact do |tr|
      tr[data_directory[key.to_s]] = serialize_messagepack(value)
    end
  end

  def get(key, klass = nil)
    raise Hypostasis::Errors::KeyNotFound if data_directory.contains?(key.to_s)
    raw_value = database.get(data_directory[key.to_s])
    deserialize_messagepack(raw_value, klass)
  end
end
