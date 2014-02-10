require 'minitest_helper'

describe Hypostasis::DataModels::ColumnGroup do
  before do
    FDB.directory.remove_if_exists(database, 'sample_columns')
    FDB.directory.remove_if_exists(database, 'indexed_columns')
    Hypostasis::Connection.create_namespace 'sample_columns', data_model: :column_group
    Hypostasis::Connection.create_namespace 'indexed_columns', data_model: :column_group
  end

  after do
    Hypostasis::Connection.destroy_namespace 'sample_columns'
    Hypostasis::Connection.destroy_namespace 'indexed_columns'
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
end