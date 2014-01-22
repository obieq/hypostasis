require 'minitest_helper'

describe Hypostasis::Document do
  let(:subject) { SampleDocument.new(name: 'John', age: 21, dob: Date.today.prev_year(21)) }

  before do
    Hypostasis::Connection.create_namespace 'sample_docs', data_model: :document
  end

  after do
    Hypostasis::Connection.destroy_namespace 'sample_docs'
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

  describe '#save' do
    let(:document_tuple) { Hypostasis::Tuple.new(SampleDocument.to_s, @document.id.to_s).to_s }

    def field_path(name, type)
      'sample_docs\\' + document_tuple + '\\' + Hypostasis::Tuple.new(name.to_s, type.to_s).to_s
    end

    before do
      @document = subject.save
    end

    it { database.get(field_path(:name, String)).must_equal 'John' }
    it { database.get(field_path(:age, Fixnum)).must_equal '21' }
    it { database.get(field_path(:dob, Date)).must_equal Date.today.prev_year(21).to_s }
  end

  describe '.find' do
    let(:document_id) { subject.save.id }

    it { SampleDocument.find(document_id).is_a?(SampleDocument).must_equal true }
    it { SampleDocument.find(document_id).id.must_equal document_id }
  end
end
