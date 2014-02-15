FDB.directory.remove_if_exists(FDB.open, 'indexed_columns')
Hypostasis::Connection.create_namespace 'indexed_columns', data_model: :column_group

class IndexedColumn
  include Hypostasis::ColumnGroup

  use_namespace 'indexed_columns'

  field :name,  type: String
  field :age,   type: Integer
  field :dob,   type: Date

  index :name
  index :age
end
