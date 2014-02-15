require 'minitest_helper'

FDB.directory.remove_if_exists(FDB.open, 'hasmany_columns')
Hypostasis::Connection.create_namespace 'hasmany_columns', data_model: :column_group

class HasManyOwnerColumnGroup
  include Hypostasis::ColumnGroup

  use_namespace 'hasmany_columns'

  field :name
  field :age

  has_many :has_many_child_column_groups
end

class HasManyChildColumnGroup
  include Hypostasis::ColumnGroup

  use_namespace 'hasmany_columns'

  field :name
  field :age

  belongs_to :has_many_owner_column_group
end

describe 'ColumnGroup has_many Relationship' do
  before do
    FDB.directory.remove_if_exists(database, 'hasmany_columns')
    Hypostasis::Connection.create_namespace 'hasmany_columns', data_model: :column_group
    @owner = HasManyOwnerColumnGroup.create(name: 'John', age: '25')
    @children = []
    @children << HasManyChildColumnGroup.create(name: 'James', age: '6', has_many_owner_column_group_id: @owner.id)
    @children << HasManyChildColumnGroup.create(name: 'Susie', age: '4', has_many_owner_column_group_id: @owner.id)
    @children << HasManyChildColumnGroup.create(name: 'Blake', age: '2', has_many_owner_column_group_id: @owner.id)
    @child = @children.shuffle.first
  end

  after do
    Hypostasis::Connection.destroy_namespace 'hasmany_columns'
  end

  it { @owner.must_respond_to :has_many_child_column_groups }
  it { @child.must_respond_to :has_many_owner_column_group }

  it { @owner.has_many_child_column_groups.is_a?(Array).must_equal true }
  it { @owner.has_many_child_column_groups.first.is_a?(HasManyChildColumnGroup).must_equal true }
  it { @owner.has_many_child_column_groups.collect {|doc| doc.id}.must_include @child.id }

  it { @child.has_many_owner_column_group.is_a?(HasManyOwnerColumnGroup).must_equal true }
  it { @child.has_many_owner_column_group.id.must_equal @owner.id }
end
