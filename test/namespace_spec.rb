require 'minitest_helper'

describe Hypostasis::Namespace do
  let(:subject) { Hypostasis::Namespace.create('demonstration') }

  before do
    subject
  end

  after do
    FDB.directory.remove_if_exists(database, %w{demonstration})
  end

  it { Hypostasis::Namespace.must_respond_to :create }

  it { subject.must_respond_to :name }
  it { subject.name.must_equal 'demonstration' }

  it { subject.must_respond_to :data_model }
  it { subject.data_model.must_equal 'key_value' }

  it { subject.must_respond_to :destroy }

  it { subject.must_respond_to :config }
  it { subject.config.must_be_kind_of Hypostasis::NamespaceConfig }

  it { FDB.directory.exists?(database, %w{demonstration}).must_equal true }
  it { FDB.directory.exists?(database, %w{demonstration config}).must_equal true }
  it { FDB.directory.exists?(database, %w{demonstration indexes}).must_equal true }
  it { FDB.directory.exists?(database, %w{demonstration data}).must_equal true }

  describe '#destroy' do
    before do
      subject = Hypostasis::Namespace.create('destroy_demo')
      subject.destroy
    end

    after do
      FDB.directory.remove_if_exists(database, 'destroy_demo')
    end

    it { FDB.directory.exists?(database, %w{destroy_demo}).must_equal false }
    it { FDB.directory.exists?(database, %w{destroy_demo config}).must_equal false }
    it { FDB.directory.exists?(database, %w{destroy_demo indexes}).must_equal false }
    it { FDB.directory.exists?(database, %w{destroy_demo data}).must_equal false }
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
      database.set(directory.create_or_open(database, %w{config})['data_model'], 'unknown'.to_msgpack)
    end

    after do
      FDB.directory.remove_if_exists(database, 'unknown_space')
    end

    let(:directory) { FDB.directory.create(database, 'unknown_space') }

    it { lambda { Hypostasis::Namespace.create('unknown_space', { data_model: :unknown }) }.must_raise Hypostasis::Errors::UnknownNamespaceDataModel }
    it { lambda { Hypostasis::Namespace.open('unknown_space') }.must_raise Hypostasis::Errors::UnknownNamespaceDataModel }
  end
end
