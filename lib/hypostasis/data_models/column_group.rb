module Hypostasis::DataModels::ColumnGroup
  include Hypostasis::DataModels::Utilities
  include Hypostasis::DataModels::ForIndexes

  def transact
    database.transact do |tr|
      yield tr
    end
  end

  def for_column_group(column_group, id = nil)
    name.to_s + '\\' + Hypostasis::Tuple.new(get_class_name(column_group), get_object_id(column_group, id)).to_s
  end

  def for_field(document, field, type)
    for_column_group(document) + '\\' + Hypostasis::Tuple.new(field.to_s, type.to_s).to_s
  end
end
