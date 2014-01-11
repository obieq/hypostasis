require 'minitest_helper'

describe Hypostasis::Connection do
  let(:subject) { Hypostasis::Connection.new }

  it { subject.must_respond_to :get }
  it { subject.must_respond_to :set }
  it { subject.must_respond_to :unset }

  it 'supports simple getting and setting' do
    subject.get('test_key').nil?.must_equal true
    subject.set('test_key', 'test_value').must_equal true
    subject.get('test_key').must_equal 'test_value'
    subject.unset('test_key').must_equal true
    subject.get('test_key').nil?.must_equal true
  end
end
