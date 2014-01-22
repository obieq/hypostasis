class SampleDocument
  include Hypostasis::Document

  use_namespace 'sample_docs'

  field :name
  field :age
  field :dob
end
