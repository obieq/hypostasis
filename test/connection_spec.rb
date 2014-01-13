require 'minitest_helper'

describe Hypostasis::Connection do
  let(:subject) { Hypostasis::Connection.new }

  it { subject.must_respond_to :get }
  it { subject.must_respond_to :set }
  it { subject.must_respond_to :unset }

  describe '#get and #set' do
    before :each do
      subject.set('preset_key', 'preset_value')
    end

    after :each do
      subject.unset('preset_key')
    end

    it { subject.get('invalid_key').nil?.must_equal true }
    it { subject.get('preset_key').must_equal 'preset_value' }
  end

  describe '#unset' do
    it 'unsets a previously set key' do
      subject.set('preset_key', 'preset_value')
      subject.get('preset_key').must_equal 'preset_value'
      subject.unset('preset_key').must_equal true
      subject.get('preset_key').nil?.must_equal true
    end

    it 'returns true for an unset key' do
      subject.get('preset_key').nil?.must_equal true
      subject.unset('preset_key').must_equal true
    end
  end

  describe '#create_namespace' do
    before :each do
      subject.create_namespace('already_created')
    end

    it { subject.create_namespace('newly_created').is_a?(Hypostasis::Namespace).must_equal true }
    it { lambda { subject.create_namespace('already_created') }.must_raise Hypostasis::Errors::NamespaceAlreadyCreated }
  end

  describe '#open_namespace' do
    before :each do
      subject.create_namespace('already_created')
    end

    it { subject.open_namespace('already_created').is_a?(Hypostasis::Namespace).must_equal true }
  end

  describe '#destroy_namespace' do
    before :each do
      subject.create_namespace('already_created')
    end

    it { subject.destroy_namespace('already_created').must_equal true }
    it { lambda { subject.destroy_namespace('not_created') }.must_raise Hypostasis::Errors::NonExistantNamespace }
  end
end
