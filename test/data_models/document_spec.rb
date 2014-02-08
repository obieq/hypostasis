require 'minitest_helper'

describe Hypostasis::Document do
  let(:subject) { SampleDocument.new(name: 'John', age: 21, dob: Date.today.prev_year(21)) }

  before do
    FDB.directory.remove_if_exists(database, 'sample_documents')
    FDB.directory.remove_if_exists(database, 'indexed_documents')
    Hypostasis::Connection.create_namespace 'sample_documents', data_model: :document
    Hypostasis::Connection.create_namespace 'indexed_documents', data_model: :document
  end

  after do
    Hypostasis::Connection.destroy_namespace 'sample_documents'
    Hypostasis::Connection.destroy_namespace 'indexed_documents'
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

  describe '.create' do
    let(:subject) { SampleDocument.create(name: 'John', age: 21, dob: Date.today.prev_year(21)) }

    after do
      subject.destroy
    end

    it { subject.id.wont_be_nil }
    it { database.get(document_path(subject)).must_equal subject.to_bson }
  end

  describe '.save' do
    before do
      subject.save
    end

    after do
      subject.destroy
    end

    it { subject.id.wont_be_nil }
    it { database.get(document_path(subject)).must_equal subject.to_bson }
  end

  describe '.find' do
    let(:document_id) { subject.save.id }
    let(:found) { SampleDocument.find(document_id) }

    after do
      subject.destroy
    end

    it { found.is_a?(SampleDocument).must_equal true }
    it { found.id.must_equal document_id }

    it { found.name.must_equal 'John' }
    it { found.age.must_equal 21 }
    it { found.dob.must_equal Date.today.prev_year(21).at_midnight.to_time }
  end

  describe '.find_where' do
    before do
      IndexedDocument.create(name: 'John', age: 21, dob: Date.today.prev_year(21))
      IndexedDocument.create(name: 'Jane', age: 21, dob: Date.today.prev_year(21))
      IndexedDocument.create(name: 'John', age: 23, dob: Date.today.prev_year(23))
      IndexedDocument.create(name: 'Tom', age: 20, dob: Date.today.prev_year(20))
    end

    it { IndexedDocument.find_where(name: 'John').size.must_equal 2 }
    it { IndexedDocument.find_where(age: 21).size.must_equal 2 }
    it { IndexedDocument.find_where(name: 'Tom').size.must_equal 1 }
    it { IndexedDocument.find_where(name: 'Tom').first.is_a?(IndexedDocument).must_equal true }

    it { IndexedDocument.find_where(name: 'John', age: 23).size.must_equal 1 }
    it { IndexedDocument.find_where(name: 'John', age: 23).first.is_a?(IndexedDocument).must_equal true }
  end
end
