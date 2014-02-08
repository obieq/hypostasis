require 'minitest_helper'

describe Hypostasis::Namespace do
  let(:subject) { Hypostasis::Namespace.new('demonstration') }

  it { Hypostasis::Namespace.must_respond_to :create }

  it { subject.must_respond_to :name }
  it { subject.name.must_equal 'demonstration' }

  it { subject.must_respond_to :data_model }
  it { subject.data_model.must_equal 'key_value' }

  it { subject.must_respond_to :destroy }

  describe '#create' do
    let(:subject) { Hypostasis::Namespace.create('create_demo') }

    before do
      FDB.directory.remove_if_exists(database, 'create_demo')
    end

    after do
      subject.destroy
    end

    it { subject.must_be_kind_of Hypostasis::Namespace }
    it { subject; FDB.directory.exists?(database, 'create_demo').must_equal true }
    it { subject; FDB.directory.open(database, 'create_demo').must_be_kind_of FDB::DirectorySubspace }
  end

  describe '#destroy' do
    let(:subject) { Hypostasis::Namespace.create('destroy_demo') }

    before do
      subject
    end

    after do
      FDB.directory.remove_if_exists(database, 'destroy_demo')
    end

    it do
      FDB.directory.exists?(database, 'destroy_demo').must_equal true
      subject.destroy
      FDB.directory.exists?(database, 'destroy_demo').must_equal false
    end

    it do
      FDB.directory.open(database, 'destroy_demo').must_be_kind_of FDB::DirectorySubspace
      subject.destroy
      lambda { FDB.directory.open(database, 'destroy_demo') }.must_raise ArgumentError
    end
  end

  describe 'for a ColumnGroup namespace' do
    before do
      subject
    end

    after do
      FDB.directory.remove_if_exists(database, 'column_space')
    end

    let(:subject) { Hypostasis::Namespace.create('column_space', { data_model: :column_group }) }
    let(:directory) { FDB.directory.open(database, 'column_space') }

    it { MessagePack.unpack(StringIO.new(database.get(directory['hypostasis']['config']))).must_equal({'data_model' => 'column_group'}) }
  end

  describe 'for an unknown namespace type' do
    before do
      database.set(directory['hypostasis']['config'], {data_model: :unknown}.to_msgpack)
    end

    after do
      FDB.directory.remove_if_exists(database, 'unknown_space')
    end

    let(:directory) { FDB.directory.create(database, 'unknown_space') }

    it { lambda { Hypostasis::Namespace.create('unknown_space', { data_model: :unknown }) }.must_raise Hypostasis::Errors::UnknownNamespaceDataModel }
    it { lambda { Hypostasis::Namespace.open('unknown_space') }.must_raise Hypostasis::Errors::UnknownNamespaceDataModel }
  end
end
