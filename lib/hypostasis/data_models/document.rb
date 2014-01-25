module Hypostasis::DataModels::Document
  def transact
    database.transact do |tr|
      yield tr
    end
  end

  def for_document(document, id = nil)
    class_name = document.is_a?(Class) ? document.to_s : document.class.to_s
    document_id = id.nil? ? document.id.to_s : id.to_s
    name.to_s + '\\' + Hypostasis::Tuple.new(class_name, document_id).to_s
  end

  def for_field(document, field, type)
    for_document(document) + '\\' + Hypostasis::Tuple.new(field.to_s, type.to_s).to_s
  end

  def for_index(document, field_name, value)
    class_name = document.is_a?(Class) ? document.to_s : document.class.to_s
    index_path = Hypostasis::Tuple.new('indexes', class_name).to_s
    value = value.to_s unless value.is_a?(Fixnum) || value.is_a?(Bignum)
    if document.is_a?(Class)
      field_path = Hypostasis::Tuple.new(field_name.to_s, value).to_s
    else
      field_path = Hypostasis::Tuple.new(field_name.to_s, value, document.id.to_s).to_s
    end
    name.to_s + '\\' + index_path + '\\' + field_path
  end
end
