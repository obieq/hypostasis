require 'minitest_helper'

describe Hypostasis::Connection do
  let(:subject) { Hypostasis::Connection.new }

  it { subject.must_respond_to :get }
  it { subject.must_respond_to :set }
end
