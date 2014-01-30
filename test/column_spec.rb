require 'minitest_helper'

describe Hypostasis::ColumnGroup do
  let(:subject) { SampleColumn.new(name: 'John', age: 21, dob: Date.today.prev_year(21)) }

  before do
    Hypostasis::Connection.create_namespace 'sample_columns', data_model: :column_group
    Hypostasis::Connection.create_namespace 'indexed_columns', data_model: :column_group
  end

  after do
    Hypostasis::Connection.destroy_namespace 'sample_columns'
    Hypostasis::Connection.destroy_namespace 'indexed_columns'
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
    let(:subject) { SampleColumn.create(name: 'John', age: 21, dob: Date.today.prev_year(21)) }

    after do
      subject.destroy
    end

    it { subject.id.wont_be_nil }
    it { database.get(column_path(subject)).must_equal 'true' }
    it { database.get(field_path(subject, :name, String)).must_equal 'John' }
    it { database.get(field_path(subject, :age, Fixnum)).must_equal '21' }
    it { database.get(field_path(subject, :dob, Date)).must_equal Date.today.prev_year(21).to_s }
  end

  describe '#save' do
    let(:subject) { SampleColumn.new(name: 'John', age: 21, dob: Date.today.prev_year(21)) }

    before do
      subject.save
    end

    after do
      subject.destroy
    end

    it { subject.id.wont_be_nil }
    it { database.get(column_path(subject)).must_equal 'true' }
    it { database.get(field_path(subject, :name, String)).must_equal 'John' }
    it { database.get(field_path(subject, :age, Fixnum)).must_equal '21' }
    it { database.get(field_path(subject, :dob, Date)).must_equal Date.today.prev_year(21).to_s }
  end

  describe '.find' do
    let(:column_id) { subject.save.id }

    after do
      subject.destroy
    end

    it { SampleColumn.find(column_id).is_a?(SampleColumn).must_equal true }
    it { SampleColumn.find(column_id).id.must_equal column_id }
  end

  describe 'indexing' do
    before do
      IndexedColumn.create(name: 'John', age: 21, dob: Date.today.prev_year(21))
      IndexedColumn.create(name: 'Jane', age: 21, dob: Date.today.prev_year(21))
      IndexedColumn.create(name: 'John', age: 23, dob: Date.today.prev_year(23))
      IndexedColumn.create(name: 'Tom', age: 20, dob: Date.today.prev_year(20))
    end

    it { database.get_range_start_with(index_path(IndexedColumn, :name)).size.must_equal 4 }
    it { database.get_range_start_with(index_path(IndexedColumn, :age)).size.must_equal 4 }

    it { database.get_range_start_with(index_path(IndexedColumn, :name, 'John')).size.must_equal 2 }
    it { database.get_range_start_with(index_path(IndexedColumn, :name, 'Jane')).size.must_equal 1 }

    it { database.get_range_start_with(index_path(IndexedColumn, :age, 21)).size.must_equal 2 }
  end

  describe '.find_where' do
    before do
      IndexedColumn.create(name: 'John', age: 21, dob: Date.today.prev_year(21))
      IndexedColumn.create(name: 'Jane', age: 21, dob: Date.today.prev_year(21))
      IndexedColumn.create(name: 'John', age: 23, dob: Date.today.prev_year(23))
      IndexedColumn.create(name: 'Tom', age: 20, dob: Date.today.prev_year(20))
    end

    it { IndexedColumn.find_where(name: 'John').size.must_equal 2 }
    it { IndexedColumn.find_where(age: 21).size.must_equal 2 }
    it { IndexedColumn.find_where(name: 'Tom').size.must_equal 1 }
    it { IndexedColumn.find_where(name: 'Tom').first.is_a?(IndexedColumn).must_equal true }

    it { IndexedColumn.find_where(name: 'John', age: 23).size.must_equal 1 }
    it { IndexedColumn.find_where(name: 'John', age: 23).first.is_a?(IndexedColumn).must_equal true }
  end
end
