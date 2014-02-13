class Hypostasis::Namespace
  attr_reader :name, :config, :directory, :data_directory, :indexes_directory

  SUPPORTED_DATA_MODELS = [:column_group, :key_value, :document]

  def initialize(namespace_name, namespace_data_model = :key_value)
    @name = namespace_name.to_s
    setup_directories
    setup_configuration(namespace_data_model)
    load_data_model
    self
  end
  self.singleton_class.send(:alias_method, :open, :new)

  def data_model
    @config[:data_model]
  end

  def destroy
    FDB.directory.remove(database, name)
  end

  def to_s
    name
  end

  def self.create(name, options = {})
    merged_options = { data_model: :key_value }.merge(options).symbolize_keys
    raise Hypostasis::Errors::UnknownNamespaceDataModel unless SUPPORTED_DATA_MODELS.include?(merged_options[:data_model].to_sym)
    directory = FDB.directory.create(database, name.to_s)
    database.set(directory['hypostasis']['config'], serialize_messagepack(merged_options))
    Hypostasis::Namespace.new(name, merged_options[:data_model])
  end

  def self.serialize_messagepack(value)
    begin
      serialized_value = value
      serialized_value = value.class.to_msgpack_type(value) if value.class.respond_to?(:to_msgpack_type)
      serialized_value.to_msgpack
    rescue StandardError
      raise Hypostasis::Errors::UnknownValueType, 'value can not be serialized to MessagePack'
    end
  end

  def serialize_messagepack(value)
    Hypostasis::Namespace.serialize_messagepack(value)
  end

  def self.deserialize_messagepack(value, klass)
    begin
      msgpack_value = MessagePack.unpack(StringIO.new(value))
      if klass.respond_to?(:from_msgpack_type)
        klass.from_msgpack_type(msgpack_value)
      else
        msgpack_value
      end
    rescue StandardError
      raise Hypostasis::Errors::UnknownValueType, 'value can not be deserialized from MessagePack'
    end
  end

  def deserialize_messagepack(value, klass)
    Hypostasis::Namespace.deserialize_messagepack(value, klass)
  end

private

  def self.database
    Hypostasis::Connection.database
  end

  def database
    Hypostasis::Namespace.database
  end

  def setup_directories
    @directory = FDB.directory.open(database, [@name])
    @config_directory = @directory.create_or_open(database, %w{config})
    @indexes_directory = @directory.create_or_open(database, %w{indexes})
    @data_directory = @directory.create_or_open(database, %w{data})
  end

  def setup_configuration(namespace_data_model)
    @config = Hypostasis::NamespaceConfig.new(self, { data_model: namespace_data_model.to_s })
  end

  def load_data_model
    case data_model
      when 'key_value'
        self.extend Hypostasis::DataModels::KeyValue
      when 'column_group'
        self.extend Hypostasis::DataModels::ColumnGroup
      when 'document'
        self.extend Hypostasis::DataModels::Document
    end
  end
end
