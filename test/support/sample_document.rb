class SampleDocument
  include Hypostasis::Document

  use_namespace 'sample_documents'

  field :name
  field :age
  field :dob
end
