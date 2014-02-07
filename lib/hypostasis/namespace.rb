class Hypostasis::Namespace
  attr_reader :name

  def initialize(name, data_model = :key_value)
    @name = name.to_s
    @config = {
        data_model: data_model.to_s
    }
    load_data_model
  end

  def data_model
    @config[:data_model]
  end

  def config
    @config = (deserialize_messagepack database.get(name), Hash).symbolize_keys
  end

  def open
    raise Hypostasis::Errors::NonExistentNamespace if database[name].nil?
    current_config = (deserialize_messagepack database.get(name), Hash).symbolize_keys
    raise Hypostasis::Errors::NamespaceDataModelMismatch if current_config[:data_model] != data_model
    self
  end

  def destroy
    database.clear_range_start_with(name)
    true
  end

  def to_s
    name
  end

  def self.create(name, options = {})
    raise Hypostasis::Errors::NamespaceAlreadyCreated unless database[name].nil?
    merged_options = { data_model: :key_value }.merge(options)

    database.transact do |tr|
      tr.set(name.to_s, serialize_messagepack(merged_options))
    end

    Hypostasis::Namespace.new(name, merged_options[:data_model])
  end

  def self.open(name)
    raise Hypostasis::Errors::NonExistentNamespace if database[name].nil?
    config_value = database.get(name)
    raise Hypostasis::Errors::CanNotReadNamespaceConfig if config_value.nil?
    current_config = (deserialize_messagepack config_value, Hash).symbolize_keys
    Hypostasis::Namespace.new(name, current_config[:data_model])
  end

private

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
end
