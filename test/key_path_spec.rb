require 'minitest_helper'

describe Hypostasis::KeyPath do
  let(:subject) { Hypostasis::KeyPath.new('hypostasis', 'demo', 'path') }

  it { lambda { Hypostasis::KeyPath.new }.must_raise Hypostasis::Errors::InvalidKeyPath }
  it { subject.to_s.must_equal 'hypostasis\demo\path' }
  it { subject.to_a.must_equal %w{hypostasis demo path} }

end
