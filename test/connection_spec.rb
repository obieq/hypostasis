require 'minitest_helper'

describe Hypostasis::Connection do
  let(:subject) { Hypostasis::Connection.open }

  describe '#create_namespace' do
    before do
      subject.destroy_namespace('already_created')
      subject.create_namespace('already_created')
    end

    after do
      subject.destroy_namespace('already_created')
      subject.destroy_namespace('newly_created')
    end

    it { subject.create_namespace('newly_created').is_a?(Hypostasis::Namespace).must_equal true }
    it { lambda { subject.create_namespace('already_created') }.must_raise Hypostasis::Errors::NamespaceAlreadyCreated }
  end

  describe '#open_namespace' do
    before do
      subject.create_namespace('already_created')
    end

    after do
      subject.destroy_namespace('already_created')
    end

    it { subject.open_namespace('already_created').is_a?(Hypostasis::Namespace).must_equal true }
  end

  describe '#destroy_namespace' do
    before do
      subject.create_namespace('already_created')
    end

    after do
      subject.destroy_namespace('already_created')
    end

    it { subject.destroy_namespace('already_created').must_equal true }
    it { subject.destroy_namespace('not_created').must_equal true }
  end
end
