require 'minitest_helper'

class HabtmParentColumnGroup
  include Hypostasis::ColumnGroup

  use_namespace 'habtm_columns'

  field :name
  field :age

  has_and_belongs_to_many :habtm_child_column_groups
end

class HabtmChildColumnGroup
  include Hypostasis::ColumnGroup

  use_namespace 'habtm_columns'

  field :name
  field :age

  has_and_belongs_to_many :habtm_parent_column_groups
end

describe 'ColumnGroup has_and_belongs_to_many Relationship' do
  let(:parent) { @parents.shuffle.first }
  let(:child) { @children.shuffle.first }

  let(:new_parent) { HabtmParentColumnGroup.create(name: 'Jason', age: '32') }
  let(:new_child) { HabtmChildColumnGroup.create(name: 'Robert', age: '1') }

  before do
    Hypostasis::Connection.create_namespace 'habtm_columns', data_model: :column_group
    @parents = []
    @children = []

    @parents << HabtmParentColumnGroup.create(name: 'John', age: '25')
    @parents << HabtmParentColumnGroup.create(name: 'Beth', age: '26')

    @children << HabtmChildColumnGroup.create(name: 'James', age: '6')
    @children << HabtmChildColumnGroup.create(name: 'Susie', age: '4')
    @children << HabtmChildColumnGroup.create(name: 'Blake', age: '2')

    @parents.each {|this_owner| this_owner.habtm_child_column_groups = @children }
    @children.each {|this_child| this_child.habtm_parent_column_groups = @parents }
  end

  after do
    Hypostasis::Connection.destroy_namespace 'habtm_columns'
  end

  it { parent.must_respond_to :habtm_child_column_groups }
  it { child.must_respond_to :habtm_parent_column_groups }

  it { parent.habtm_child_column_groups.must_be_kind_of Array }
  it { parent.habtm_child_column_groups.first.must_be_kind_of HabtmChildColumnGroup }
  it { parent.habtm_child_column_groups.collect {|doc| doc.id}.must_include child.id }

  it { child.habtm_parent_column_groups.must_be_kind_of Array }
  it { child.habtm_parent_column_groups.first.must_be_kind_of HabtmParentColumnGroup }
  it { child.habtm_parent_column_groups.collect {|doc| doc.id}.must_include parent.id }

  describe 'adding via <<' do
    before do
      parent.habtm_child_column_groups << new_child
      child.habtm_parent_column_groups << new_parent
    end

    it { parent.habtm_child_column_groups.collect {|doc| doc.id}.must_include new_child.id }
    it { child.habtm_parent_column_groups.collect {|doc| doc.id}.must_include new_parent.id }
  end
end
