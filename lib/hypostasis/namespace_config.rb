class Hypostasis::NamespaceConfig
  DEFAULT_CONFIG = { data_model: :key_value }

  def initialize(namespace, config_options = {})
    @namespace = namespace
    @config = DEFAULT_CONFIG.merge(config_options)
    check_config
    store_config
  end

  def [](key)
    @config[key.to_sym]
  end

  def []=(key, value)
    @config[key.to_sym] = value.respond_to?(:to_msgpack) ? value : value.to_s
    store_config
  end

  private

  def directory
    @namespace.directory
  end

  def database
    Hypostasis::Connection.database
  end

  def config_path
    @config_path ||= directory.open(database, %w{config})
  end

  def check_config
    existing_config = {}
    config_range = config_path.range
    config_keys = nil
    database.transact do |tr|
      config_keys = tr.get_range(config_range[0], config_range[1]).to_a
    end
    return true if config_keys.nil? || config_keys.empty?
    config_keys.each do |key|
      existing_config[config_path.unpack(key.key).first.to_sym] = MessagePack.unpack(key.value)
    end
    raise Hypostasis::Errors::UnknownNamespaceDataModel unless Hypostasis::Namespace::SUPPORTED_DATA_MODELS.include?(existing_config[:data_model].to_sym)
    raise Hypostasis::Errors::NamespaceDataModelMismatch unless existing_config[:data_model] == @config[:data_model].to_s
    @config = existing_config.merge(@config)
  end

  def store_config
    database.transact do |tr|
      @config.each do |key, value|
        tr.set(config_path[key.to_s], value.to_msgpack)
      end
    end
  end
end