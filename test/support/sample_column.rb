class SampleColumn
  include Hypostasis::ColumnGroup

  use_namespace 'sample_columns'

  field :name,  type: String
  field :age,   type: Integer
  field :dob,   type: Date
end
