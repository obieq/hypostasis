module Hypostasis::DataModels::Utilities
  def reconstitute_value(tuple, raw_value)
    data_type = tuple.to_a.last
    case data_type
      when 'Fixnum'
        Integer(raw_value)
      when 'Bignum'
        Integer(raw_value)
      when 'Float'
        Float(raw_value)
      when 'String'
        raw_value
      when 'Date'
        Date.parse(raw_value)
      when 'DateTime'
        DateTime.parse(raw_value)
      when 'Time'
        Time.parse(raw_value)
      when 'TrueClass'
        true
      when 'FalseClass'
        false
      when 'NilClass'
        nil
      else
        raise Hypostasis::Errors::UnknownValueType
    end
  end
end
