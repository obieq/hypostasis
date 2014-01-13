require 'fdb'

FDB.api_version 100

class Hypostasis::Connection
  attr_reader :database

  def initialize
    @database = FDB.open
  end

  def get(key)
    database[key.to_s]
  end

  def set(key, value)
    (database[key.to_s] = value.to_s) == value.to_s
  end

  def unset(key)
    database.clear(key).nil?
  end

  def create_namespace(name, options = {data_model: :key_value})
    config_key = "hypostasis\\config\\namespaces\\#{name.to_s}"
    raise Hypostasis::Errors::NamespaceAlreadyCreated unless database[config_key].nil?
    database[config_key] = Marshal.dump(options)
    Hypostasis::Namespace.new(name, options[:data_model])
  end

  def open_namespace(name)
    config_key = "hypostasis\\config\\namespaces\\#{name.to_s}"
    raise Hypostasis::Errors::NonExistantNamespace if database[config_key].nil?
    options = Marshal.load(database[config_key])
    Hypostasis::Namespace.new(name, options[:data_model])
  end

  def destroy_namespace(name)
    config_key = "hypostasis\\config\\namespaces\\#{name.to_s}"
    raise Hypostasis::Errors::NonExistantNamespace if database[config_key].nil?
    database.clear_range_start_with(config_key)
    database.clear_range_start_with(name.to_s)
    true
  end
end
