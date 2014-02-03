require 'minitest_helper'

class HasOneOwnerColumnGroup
  include Hypostasis::ColumnGroup

  use_namespace 'hasone_columns'

  field :name
  field :age

  has_one :has_one_child_column_group
end

class HasOneChildColumnGroup
  include Hypostasis::ColumnGroup

  use_namespace 'hasone_columns'

  field :name
  field :age

  belongs_to :has_one_owner_column_group
end

describe 'ColumnGroup has_one Relationship' do
  before do
    Hypostasis::Connection.create_namespace 'hasone_columns', data_model: :column_group
    @owner = HasOneOwnerColumnGroup.create(name: 'John', age: '25')
    @child = HasOneChildColumnGroup.create(name: 'James', age: '6', has_one_owner_column_group_id: @owner.id)
  end

  after do
    Hypostasis::Connection.destroy_namespace 'hasone_columns'
  end

  it { @owner.must_respond_to :has_one_child_column_group }
  it { @child.must_respond_to :has_one_owner_column_group }

  it { @owner.has_one_child_column_group.is_a?(HasOneChildColumnGroup).must_equal true }
  it { @owner.has_one_child_column_group.id.must_equal @child.id }

  it { @child.has_one_owner_column_group.is_a?(HasOneOwnerColumnGroup).must_equal true }
  it { @child.has_one_owner_column_group.id.must_equal @owner.id }
end
