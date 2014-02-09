require 'minitest_helper'

FDB.directory.remove_if_exists(FDB.open, 'hasone_docs')
Hypostasis::Connection.create_namespace 'hasone_docs', data_model: :document

class HasOneOwnerDocument
  include Hypostasis::Document

  use_namespace 'hasone_docs'

  field :name
  field :age

  has_one :has_one_child_document
end

class HasOneChildDocument
  include Hypostasis::Document

  use_namespace 'hasone_docs'

  field :name
  field :age

  belongs_to :has_one_owner_document
end

describe 'Document has_one Relationship' do
  before do
    FDB.directory.remove_if_exists(database, 'hasone_docs')
    Hypostasis::Connection.create_namespace 'hasone_docs', data_model: :document
    @owner = HasOneOwnerDocument.create(name: 'John', age: '25')
    @child = HasOneChildDocument.create(name: 'James', age: '6', has_one_owner_document_id: @owner.id)
  end

  after do
    Hypostasis::Connection.destroy_namespace 'hasone_docs'
  end

  it { @owner.must_respond_to :has_one_child_document }
  it { @child.must_respond_to :has_one_owner_document }

  it { @owner.has_one_child_document.is_a?(HasOneChildDocument).must_equal true }
  it { @owner.has_one_child_document.id.must_equal @child.id }

  it { @child.has_one_owner_document.is_a?(HasOneOwnerDocument).must_equal true }
  it { @child.has_one_owner_document.id.must_equal @owner.id }
end
