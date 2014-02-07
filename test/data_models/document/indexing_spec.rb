require 'minitest_helper'

describe 'Hypostasis::Document indexing' do
  before do
    Hypostasis::Connection.create_namespace 'indexed_documents', data_model: :document

    IndexedDocument.create(name: 'John', age: 21, dob: Date.today.prev_year(21))
    IndexedDocument.create(name: 'Jane', age: 21, dob: Date.today.prev_year(21))
    IndexedDocument.create(name: 'John', age: 23, dob: Date.today.prev_year(23))
    IndexedDocument.create(name: 'Tom', age: 20, dob: Date.today.prev_year(20))
  end

  after do
    Hypostasis::Connection.destroy_namespace 'indexed_documents'
  end

  it { database.get_range_start_with(index_path(IndexedDocument, :name)).size.must_equal 4 }
  it { database.get_range_start_with(index_path(IndexedDocument, :age)).size.must_equal 4 }

  it { database.get_range_start_with(index_path(IndexedDocument, :name, 'John')).size.must_equal 2 }
  it { database.get_range_start_with(index_path(IndexedDocument, :name, 'Jane')).size.must_equal 1 }

  it { database.get_range_start_with(index_path(IndexedDocument, :age, 21)).size.must_equal 2 }
end
