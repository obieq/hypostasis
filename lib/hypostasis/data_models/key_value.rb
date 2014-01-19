module Hypostasis::DataModels::KeyValue
  def set(key, value)
    key_path = "#{name}\\#{Hypostasis::Tuple.new(key.to_s, value.class.to_s).to_s}"
    database.set(key_path, value.to_s)
  end

  def get(key)
    key_path = "#{name}\\#{Hypostasis::Tuple.new(key.to_s).to_s}"
    key = database.get_range_start_with(key_path).first.key
    value = database.get_range_start_with(key_path).first.value
    data_type = Hypostasis::Tuple.unpack(key.to_s.split('\\').last).to_a.last
    case data_type
      when 'Fixnum'
        Integer(value)
      when 'Bignum'
        Integer(value)
    end
  end
end
