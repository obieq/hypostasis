class IndexedDocument
  include Hypostasis::Document

  use_namespace 'indexed_documents'

  field :name
  field :age
  field :dob

  index :name
  index :age
end
