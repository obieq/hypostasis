require 'minitest_helper'

describe Hypostasis::Namespace do
  let(:subject) { Hypostasis::Namespace.new('demonstration', :document) }

  it { subject.must_respond_to :name }
  it { subject.name.must_equal 'demonstration' }

  it { subject.must_respond_to :data_model }
  it { subject.data_model.must_equal :document }

  it "sets 'hypostasis/config/namespaces/demonstration' key"
  it "sets 'hypostasis/config/namespaces/demonstration/data_model' key"
end
