FDB.directory.remove_if_exists(FDB.open, 'sample_documents')
Hypostasis::Connection.create_namespace 'sample_documents', data_model: :document

class SampleDocument
  include Hypostasis::Document

  use_namespace 'sample_documents'

  field :name
  field :age
  field :dob
end
