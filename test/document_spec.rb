require 'minitest_helper'

describe Hypostasis::Document do
  let(:subject) { SampleDocument.new(name: 'John', age: 21, dob: Date.today.prev_year(21)) }

  before do
    Hypostasis::Connection.create_namespace 'sample_documents', data_model: :document
  end

  after do
    Hypostasis::Connection.destroy_namespace 'sample_documents'
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
end
