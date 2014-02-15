require 'minitest_helper'

describe 'Hypostasis::Document indexing' do
  let(:directory) { IndexedDocument.namespace.indexes_directory }

  def get_range_for_document_field(field_name, value = nil)
    if value.nil?
      range = directory[IndexedDocument.to_s][field_name.to_s].range
    else
      range = directory[IndexedDocument.to_s][field_name.to_s][value.to_msgpack].range
    end

    database.get_range(range[0], range[1])
  end

  before do
    FDB.directory.remove_if_exists(database, 'indexed_documents')
    Hypostasis::Connection.create_namespace 'indexed_documents', data_model: :document

    @documents = []
    @documents << IndexedDocument.create(name: 'John', age: 21, dob: Date.today.prev_year(21))
    @documents << IndexedDocument.create(name: 'Jane', age: 21, dob: Date.today.prev_year(21))
    @documents << IndexedDocument.create(name: 'John', age: 23, dob: Date.today.prev_year(23))
    @documents << IndexedDocument.create(name: 'Tom', age: 20, dob: Date.today.prev_year(20))
  end

  after do
    @documents.each {|doc| doc.destroy}
    Hypostasis::Connection.destroy_namespace 'indexed_documents'
  end

  it { get_range_for_document_field(:name).size.must_equal 4 }
  it { get_range_for_document_field(:age).size.must_equal 4 }

  it { get_range_for_document_field(:name, 'John').size.must_equal 2 }
  it { get_range_for_document_field(:name, 'Jane').size.must_equal 1 }

  it { get_range_for_document_field(:age, 21).size.must_equal 2 }
end
