class IndexedColumn
  include Hypostasis::ColumnGroup

  use_namespace 'indexed_columns'

  field :name,  type: String
  field :age,   type: Integer
  field :dob,   type: Date

  index :name
  index :age
end
