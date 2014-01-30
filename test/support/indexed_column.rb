class IndexedColumn
  include Hypostasis::ColumnGroup

  use_namespace 'indexed_columns'

  field :name
  field :age
  field :dob

  index :name
  index :age
end
