require 'date'

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
      when 'Float'
        Float(value)
      when 'String'
        value
      when 'Date'
        Date.parse(value)
      when 'DateTime'
        DateTime.parse(value)
      when 'Time'
        Time.parse(value)
      when 'TrueClass'
        true
      when 'FalseClass'
        false
      else
        raise Hypostasis::Errors::UnknownValueType
    end
  end
end
