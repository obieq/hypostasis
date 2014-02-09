FDB.directory.remove_if_exists(FDB.open, 'sample_columns')
Hypostasis::Connection.create_namespace 'sample_columns', data_model: :column_group

class SampleColumn
  include Hypostasis::ColumnGroup

  use_namespace 'sample_columns'

  field :name,  type: String
  field :age,   type: Integer
  field :dob,   type: Date
end
