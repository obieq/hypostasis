FDB.directory.remove_if_exists(FDB.open, 'indexed_documents')
Hypostasis::Connection.create_namespace 'indexed_documents', data_model: :document

class IndexedDocument
  include Hypostasis::Document

  use_namespace 'indexed_documents'

  field :name
  field :age
  field :dob

  index :name
  index :age
end
