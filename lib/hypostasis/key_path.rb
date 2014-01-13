class Hypostasis::KeyPath
  def initialize(*path)
    @path = path.to_a
    raise Hypostasis::Errors::InvalidKeyPath if @path.empty?
    self
  end

  def to_s
    @path.join('\\')
  end

  def to_a
    @path
  end
end
