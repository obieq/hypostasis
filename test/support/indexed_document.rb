class IndexedDocument
  include Hypostasis::Document

  use_namespace 'indexed_docs'

  field :name
  field :age
  field :dob

  index :name
  index :age
end
