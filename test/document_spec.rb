require 'minitest_helper'

describe Hypostasis::Document do
  let(:subject) { SampleDocument.new(name: 'John', age: 21, dob: Date.today.prev_year(21)) }

  before do
    Hypostasis::Connection.create_namespace 'sample_docs', data_model: :document
    Hypostasis::Connection.create_namespace 'indexed_docs', data_model: :document
  end

  after do
    Hypostasis::Connection.destroy_namespace 'sample_docs'
    Hypostasis::Connection.destroy_namespace 'indexed_docs'
  end

  it { subject.must_respond_to :name }
  it { subject.must_respond_to :age }
  it { subject.must_respond_to :dob }

  it { subject.must_respond_to :name= }
  it { subject.must_respond_to :age= }
  it { subject.must_respond_to :dob= }

  it { subject.name.must_equal 'John' }
  it { subject.age.must_equal 21 }
  it { subject.dob.must_equal Date.today.prev_year(21) }

  it { subject.must_respond_to :save }

  describe '#create' do
    let(:subject) { SampleDocument.create(name: 'John', age: 21, dob: Date.today.prev_year(21)) }

    after do
      subject.destroy
    end

    it { subject.id.wont_be_nil }
    it { database.get(document_path(subject)).must_equal 'true' }
    it { database.get(field_path(subject, :name, String)).must_equal 'John' }
    it { database.get(field_path(subject, :age, Fixnum)).must_equal '21' }
    it { database.get(field_path(subject, :dob, Date)).must_equal Date.today.prev_year(21).to_s }
  end

  describe '#save' do
    let(:subject) { SampleDocument.new(name: 'John', age: 21, dob: Date.today.prev_year(21)) }

    before do
      subject.save
    end

    after do
      subject.destroy
    end

    it { subject.id.wont_be_nil }
    it { database.get(document_path(subject)).must_equal 'true' }
    it { database.get(field_path(subject, :name, String)).must_equal 'John' }
    it { database.get(field_path(subject, :age, Fixnum)).must_equal '21' }
    it { database.get(field_path(subject, :dob, Date)).must_equal Date.today.prev_year(21).to_s }
  end

  describe '.find' do
    let(:document_id) { subject.save.id }

    after do
      subject.destroy
    end

    it { SampleDocument.find(document_id).is_a?(SampleDocument).must_equal true }
    it { SampleDocument.find(document_id).id.must_equal document_id }
  end

  describe 'indexing' do
    before do
      IndexedDocument.create(name: 'John', age: 21, dob: Date.today.prev_year(21))
      IndexedDocument.create(name: 'Jane', age: 21, dob: Date.today.prev_year(21))
      IndexedDocument.create(name: 'John', age: 23, dob: Date.today.prev_year(23))
      IndexedDocument.create(name: 'Tom', age: 20, dob: Date.today.prev_year(20))
    end

    it { database.get_range_start_with(index_path(IndexedDocument, :name)).size.must_equal 4 }
    it { database.get_range_start_with(index_path(IndexedDocument, :age)).size.must_equal 4 }

    it { database.get_range_start_with(index_path(IndexedDocument, :name, 'John')).size.must_equal 2 }
    it { database.get_range_start_with(index_path(IndexedDocument, :name, 'Jane')).size.must_equal 1 }

    it { database.get_range_start_with(index_path(IndexedDocument, :age, 21)).size.must_equal 2 }
  end
end
