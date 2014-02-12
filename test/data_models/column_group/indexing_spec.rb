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
    let(:directory) { IndexedColumn.namespace.indexes_directory }

    def get_range_for_column(field_name, value = nil)
      if value.nil?
        range = directory[IndexedColumn.to_s][field_name.to_s].range
      else
        range = directory[IndexedColumn.to_s][field_name.to_s][value.to_msgpack].range
      end

      database.get_range(range[0], range[1])
    end

    before do
      @indexed_columns = []
      @indexed_columns << IndexedColumn.create(name: 'John', age: 21, dob: Date.today.prev_year(21))
      @indexed_columns << IndexedColumn.create(name: 'Jane', age: 21, dob: Date.today.prev_year(21))
      @indexed_columns << IndexedColumn.create(name: 'John', age: 23, dob: Date.today.prev_year(23))
      @indexed_columns << IndexedColumn.create(name: 'Tom', age: 20, dob: Date.today.prev_year(20))
    end

    after do
      @indexed_columns.each {|ic| ic.destroy}
    end

    it { get_range_for_column(:name).size.must_equal 4 }
    it { get_range_for_column(:age).size.must_equal 4 }

    it { get_range_for_column(:name, 'John').size.must_equal 2 }
    it { get_range_for_column(:name, 'Jane').size.must_equal 1 }

    it { get_range_for_column(:age, 21).size.must_equal 2 }
  end
end
