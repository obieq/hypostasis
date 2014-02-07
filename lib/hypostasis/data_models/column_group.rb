module Hypostasis::DataModels::ColumnGroup
  include Hypostasis::DataModels::Utilities
  include Hypostasis::DataModels::ForIndexes

  def transact
    database.transact do |tr|
      yield tr
    end
  end

  def for_column_group(column_group, id = nil)
    name.to_s + '\\' + get_class_name(column_group) + '\\' + get_object_id(column_group, id)
  end

  def for_field(document, field_name)
    for_column_group(document) + '\\' + field_name.to_s
  end
end
