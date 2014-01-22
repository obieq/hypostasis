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
end
