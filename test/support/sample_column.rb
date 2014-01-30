class SampleColumn
  include Hypostasis::ColumnGroup

  use_namespace 'sample_columns'

  field :name
  field :age
  field :dob
end
