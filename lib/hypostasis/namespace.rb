class Hypostasis::Namespace
  attr_reader :name, :data_model

  def initialize(name, data_model)
    @name = name.to_s
    @data_model = data_model.to_sym
  end

  def key_path
    @key_path ||= Hypostasis::KeyPath.new(name)
  end

  def config_path
    @config_path ||= Hypostasis::Connection.config_path.extend_path(name)
  end
end
