module Hypostasis::DataModels::Document
  include Hypostasis::DataModels::Utilities
  include Hypostasis::DataModels::ForIndexes

  def transact
    database.transact do |tr|
      yield tr
    end
  end

  def for_document(document, id = nil)
    name.to_s + '\\' + Hypostasis::Tuple.new(get_class_name(document), get_object_id(document, id)).to_s
  end
end
