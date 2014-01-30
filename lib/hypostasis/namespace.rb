class Hypostasis::Namespace
  attr_reader :name, :data_model

  def initialize(name, data_model = :key_value)
    @name = name.to_s
    @data_model = data_model.to_sym
    load_data_model
  end

  def open
    raise Hypostasis::Errors::NonExistentNamespace if database[name].nil?
    data_model = database.get(name + '\\' + Hypostasis::Tuple.new('config','data_model').to_s)
    raise Hypostasis::Errors::NamespaceDataModelMismatch if data_model != @data_model.to_s
    self
  end

  def destroy
    database.clear_range_start_with(@name)
    true
  end

  def to_s
    @name
  end

  def self.create(name, options = {})
    raise Hypostasis::Errors::NamespaceAlreadyCreated unless database[name].nil?
    merged_options = { data_model: :key_value }.merge(options)

    database.transact do |tr|
      tr.set(name.to_s, 'true')
      tr.set(name.to_s + '\\' + Hypostasis::Tuple.new('config','data_model').to_s, merged_options[:data_model].to_s)
    end

    Hypostasis::Namespace.new(name, merged_options[:data_model])
  end

  def self.open(name)
    raise Hypostasis::Errors::NonExistentNamespace if database[name].nil?
    data_model = database.get(name + '\\' + Hypostasis::Tuple.new('config','data_model').to_s)
    raise Hypostasis::Errors::CanNotReadNamespaceConfig if data_model.nil?
    Hypostasis::Namespace.new(name, data_model)
  end

private

  def self.database
    Hypostasis::Connection.database
  end

  def database
    Hypostasis::Namespace.database
  end

  def load_data_model
    case @data_model
      when :key_value
        self.extend Hypostasis::DataModels::KeyValue
      when :column_group
        self.extend Hypostasis::DataModels::ColumnGroup
      when :document
        self.extend Hypostasis::DataModels::Document
      else
        raise Hypostasis::Errors::UnknownNamespaceDataModel, "#{@data_model} unknown"
    end
  end
end
