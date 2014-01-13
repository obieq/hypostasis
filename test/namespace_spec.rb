require 'minitest_helper'

describe Hypostasis::Namespace do
  let(:subject) { Hypostasis::Namespace.new('demonstration', :document) }

  it { subject.must_respond_to :name }
  it { subject.name.must_equal 'demonstration' }

  it { subject.must_respond_to :data_model }
  it { subject.data_model.must_equal :document }

  it { subject.must_respond_to :key_path }
  it { subject.key_path.is_a?(Hypostasis::KeyPath).must_equal true }
  it { subject.key_path.to_a.must_equal %w{demonstration} }

  it { subject.must_respond_to :config_path }
  it { subject.config_path.is_a?(Hypostasis::KeyPath).must_equal true }
  it { subject.config_path.to_a.must_equal %w{hypostasis config namespaces demonstration} }
end
