class Hypostasis::KeyPath
  def initialize(*path)
    @path = path.to_a.flatten
    raise Hypostasis::Errors::InvalidKeyPath if @path.empty?
    self
  end

  def to_s
    @path.join('\\')
  end

  def to_a
    @path
  end

  def extend_path(*extension)
    return self if extension.empty?
    extended_path = @path + extension.to_a
    Hypostasis::KeyPath.new(extended_path)
  end

  def move_up(count = 0)
    return self if count <= 0
    raise Hypostasis::Errors::KeyPathExhausted if count >= @path.size
    new_path = @path
    new_path.pop(count)
    Hypostasis::KeyPath.new(new_path)
  end
end
