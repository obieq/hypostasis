class Hypostasis::Namespace
  attr_reader :name, :config, :directory

  SUPPORTED_DATA_MODELS = [:column_group, :key_value, :document]

  def initialize(namespace_name, namespace_data_model = :key_value)
    @name = namespace_name.to_s
    @config = { data_model: namespace_data_model.to_s }
    directory = FDB.directory.open(database, [@name])
    raw_config_value = database.get(directory['hypostasis']['config'])
    raise Hypostasis::Errors::CanNotReadNamespaceConfig if raw_config_value.nil?
    retrieved_config = deserialize_messagepack(raw_config_value, Hash).symbolize_keys
    raise Hypostasis::Errors::UnknownNamespaceDataModel unless SUPPORTED_DATA_MODELS.include?(retrieved_config[:data_model].to_sym)
    raise Hypostasis::Errors::NamespaceDataModelMismatch unless retrieved_config[:data_model] == @config[:data_model]
    @directory = directory
    @config_directory = @directory.create_or_open(database, %w{config})
    @indexes_directory = @directory.create_or_open(database, %w{indexes})
    @data_directory = @directory.create_or_open(database, %w{data})
    @config.merge!(retrieved_config)
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

  #def self.open(name)
  #  directory = FDB.directory.open(database, name.to_s)
  #  raw_config_value = database.get(directory['hypostasis']['config'])
  #  raise Hypostasis::Errors::CanNotReadNamespaceConfig if raw_config_value.nil?
  #  current_config = deserialize_messagepack(raw_config_value, Hash).symbolize_keys
  #  Hypostasis::Namespace.new(name, current_config[:data_model])
  #end

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

  def key_path_for(key)
    directory[key.to_s]
  end

  def self.database
    Hypostasis::Connection.database
  end

  def database
    Hypostasis::Namespace.database
  end

  def load_data_model
    case data_model
      when 'key_value'
        self.extend Hypostasis::DataModels::KeyValue
      when 'column_group'
        self.extend Hypostasis::DataModels::ColumnGroup
      when 'document'
        self.extend Hypostasis::DataModels::Document
      else
        raise Hypostasis::Errors::UnknownNamespaceDataModel, "#{data_model} unknown"
    end
  end
end
