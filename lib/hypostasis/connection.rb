require 'singleton'
require 'fdb'

FDB.api_version 200

class Hypostasis::Connection
  include ::Singleton

  def self.open
    self
  end

  def self.database
    @@database ||= FDB.open
  end

  def self.create_namespace(name, options = {})
    Hypostasis::Namespace.create(name, options)
  end

  def self.open_namespace(name)
    Hypostasis::Namespace.open(name)
  end

  def self.destroy_namespace(name)
    FDB.directory.remove_if_exists(database, name.to_s)
    database.clear_range_start_with(name.to_s)
    true
  end
end
