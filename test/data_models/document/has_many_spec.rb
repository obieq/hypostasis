require 'minitest_helper'

class HasManyOwnerDocument
  include Hypostasis::Document

  use_namespace 'hasmany_docs'

  field :name
  field :age

  has_many :has_many_child_documents
end

class HasManyChildDocument
  include Hypostasis::Document

  use_namespace 'hasmany_docs'

  field :name
  field :age

  belongs_to :has_many_owner_document
end

describe 'Document has_many Relationship' do
  before do
    FDB.directory.remove_if_exists(database, 'hasmany_docs')
    Hypostasis::Connection.create_namespace 'hasmany_docs', data_model: :document
    @owner = HasManyOwnerDocument.create(name: 'John', age: '25')
    @children = []
    @children << HasManyChildDocument.create(name: 'James', age: '6', has_many_owner_document_id: @owner.id)
    @children << HasManyChildDocument.create(name: 'Susie', age: '4', has_many_owner_document_id: @owner.id)
    @children << HasManyChildDocument.create(name: 'Blake', age: '2', has_many_owner_document_id: @owner.id)
    @child = @children.shuffle.first
  end

  after do
    Hypostasis::Connection.destroy_namespace 'hasmany_docs'
  end

  it { @owner.must_respond_to :has_many_child_documents }
  it { @child.must_respond_to :has_many_owner_document }

  it { @owner.has_many_child_documents.is_a?(Array).must_equal true }
  it { @owner.has_many_child_documents.first.is_a?(HasManyChildDocument).must_equal true }
  it { @owner.has_many_child_documents.collect {|doc| doc.id}.must_include @child.id }

  it { @child.has_many_owner_document.is_a?(HasManyOwnerDocument).must_equal true }
  it { @child.has_many_owner_document.id.must_equal @owner.id }
end
