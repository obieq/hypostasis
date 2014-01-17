class Hypostasis::Database
  def initialize(name, type)
    @name = name.to_s
    @type = type.to_s
    @@connection ||= Hypostasis::Connection.new
    setup_database unless database_exists?
  end
  self.singleton_class.send(:alias_method, :open, :new)

private

  def setup_database
    @@connection.database.set(FDB::Tuple.pack([@name, 'config', 'type', @type]), '')
    @@connection.database.set(FDB::Tuple.pack([@name, 'config', 'version', 1]), '')
  end

  def database_exists?
    type_correct = (@@connection.database.get(FDB::Tuple.pack([@name, 'config', 'type', @type])) == '')
    version_correct = (@@connection.database.get(FDB::Tuple.pack([@name, 'config', 'version', 1])) == '')
    type_correct && version_correct
  end
end
