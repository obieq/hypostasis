class Hypostasis::Namespace
  attr_reader :name, :data_model

  def initialize(name, data_model)
    @name = name.to_s
    @data_model = data_model.to_sym

    #self.setup
  end

private

  #def setup
  #
  #end

end
