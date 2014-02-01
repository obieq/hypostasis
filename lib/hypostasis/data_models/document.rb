module Hypostasis::DataModels::Document
  include Hypostasis::DataModels::Utilities
  include Hypostasis::DataModels::ForIndexes

  def transact
    database.transact do |tr|
      yield tr
    end
  end

  def for_document(document, id = nil)
    class_name = get_class_name(document)
    document_id = get_object_id(document, id)
    name.to_s + '\\' + Hypostasis::Tuple.new(class_name, document_id).to_s
  end
end
