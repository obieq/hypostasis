class Hypostasis::Key
  def initialize(key_path, value = nil)
    @key_path = key_path
  end

  def first
    unpack_tuple(decomposed_key.first)
  end

  def last
    unpack_tuple(decomposed_key.last)
  end

  def [](index)
    unpack_tuple(decomposed_key[index.to_i])
  end

private

  def decomposed_key
    @decomposed_key ||= @key_path.split('\\')
  end

  def unpack_tuple(key)
    begin
      Hypostasis::Tuple.unpack(key)
    rescue RuntimeError => e
      if e.message.match(/^Unknown data type in DB:/)
        key
      else
        raise e
      end
    end
  end

end
