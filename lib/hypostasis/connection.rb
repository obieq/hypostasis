require 'fdb'

FDB.api_version 100

class Hypostasis::Connection
  attr_reader :database

  @@config_key = Hypostasis::KeyPath.new('hypostasis', 'config', 'namespaces')

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
    path = @@config_key.extend_path(name.to_s).to_s
    raise Hypostasis::Errors::NamespaceAlreadyCreated unless database[path].nil?
    database[path] = Marshal.dump(options)
    Hypostasis::Namespace.new(name, options[:data_model])
  end

  def open_namespace(name)
    path = @@config_key.extend_path(name.to_s).to_s
    raise Hypostasis::Errors::NonExistentNamespace if database[path].nil?
    options = Marshal.load(database[path])
    Hypostasis::Namespace.new(name, options[:data_model])
  end

  def destroy_namespace(name)
    path = @@config_key.extend_path(name.to_s).to_s
    raise Hypostasis::Errors::NonExistentNamespace if database[path].nil?
    database.clear_range_start_with(path)
    database.clear_range_start_with(name.to_s)
    true
  end
end
