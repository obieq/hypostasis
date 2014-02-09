module Hypostasis::DataModels::ColumnGroup
  include Hypostasis::DataModels::Utilities
  include Hypostasis::DataModels::ForIndexes

  def transact
    database.transact do |tr|
      yield tr
    end
  end

  def for_column_group(column_group, id = nil)
    directory[get_class_name(column_group)][get_object_id(column_group, id)]
  end

  def for_field(column_group, field_name)
    for_column_group(column_group)[field_name.to_s]
  end
end
