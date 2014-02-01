module Hypostasis::DataModels::ForIndexes
  def for_index(object, field_name, value)
    index_path = Hypostasis::Tuple.new('indexes', get_class_name(object)).to_s
    value = value.to_s unless value.is_a?(Fixnum) || value.is_a?(Bignum)
    if document.is_a?(Class)
      field_path = Hypostasis::Tuple.new(field_name.to_s, value).to_s
    else
      field_path = Hypostasis::Tuple.new(field_name.to_s, value, document.id.to_s).to_s
    end
    name.to_s + '\\' + index_path + '\\' + field_path
  end
end
