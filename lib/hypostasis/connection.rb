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
end
