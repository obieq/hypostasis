class SampleFamily
  include Hypostasis::ColumnFamily

  use_namespace 'sample_families'

  column :name
  column :age
  column :dob
end
