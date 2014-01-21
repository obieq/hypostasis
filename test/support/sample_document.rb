class SampleDocument
  include Hypostasis::Document

  use_namespace 'sample_docs'

  field :name, type: String
  field :age,  type: Fixnum
  field :dob,  type: Date
end
