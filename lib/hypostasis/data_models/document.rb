module Hypostasis::DataModels::Document
  def transact
    database.transact do |tr|
      yield tr
    end
  end

  def for_document(document)
    name.to_s + '\\' + Hypostasis::Tuple.new(document.class.to_s, document.id.to_s).to_s
  end

  def for_field(document, field, type)
    for_document(document) + '\\' + Hypostasis::Tuple.new(field.to_s, type.to_s).to_s
  end
end
