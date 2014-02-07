require 'minitest_helper'

describe Hypostasis::Namespace do
  let(:subject) { Hypostasis::Namespace.new('demonstration') }

  it { subject.must_respond_to :name }
  it { subject.name.must_equal 'demonstration' }

  it { subject.must_respond_to :data_model }
  it { subject.data_model.must_equal :key_value }

  it { subject.must_respond_to :destroy }

  describe '#destroy' do
    before do
      Hypostasis::Connection.destroy_namespace('destroy_demo')
    end

    it {
      ns = Hypostasis::Namespace.create('destroy_demo')
      database.get('destroy_demo').must_equal 'true'
      ns.destroy
      database.get('destroy_demo').nil?.must_equal true
    }
  end

  describe 'for a ColumnGroup namespace' do
    before do
      subject
    end

    after do
      subject.destroy
    end

    let(:subject) { Hypostasis::Namespace.create('column_space', { data_model: :column_group }) }

    it { database.get('column_space\\' + Hypostasis::Tuple.new(['config','data_model']).to_s).must_equal 'column_group' }
  end

  describe 'for an unknown namespace type' do
    after do
      Hypostasis::Connection.destroy_namespace('unknown_space')
    end

    it { lambda { Hypostasis::Namespace.create('unknown_space', { data_model: :unknown }) }.must_raise Hypostasis::Errors::UnknownNamespaceDataModel }
    it {
      database.set('unknown_space', 'true')
      database.set('unknown_space\\' + Hypostasis::Tuple.new(['config','data_model']).to_s, 'unknown')

      lambda {
        Hypostasis::Namespace.open('unknown_space')
      }.must_raise Hypostasis::Errors::UnknownNamespaceDataModel
    }
  end
end
