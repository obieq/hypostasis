require 'minitest_helper'

describe Hypostasis::Key do
  let(:subject) { Hypostasis::Key.new('simple\\path\\example') }

  it { subject.must_respond_to :[] }
  it { subject.must_respond_to :first }
  it { subject.must_respond_to :last }

  it { subject[0].must_equal 'simple' }
  it { subject[1].must_equal 'path' }
  it { subject[2].must_equal 'example' }

  it { subject.first.must_equal 'simple' }
  it { subject.last.must_equal 'example'}

  describe 'with Tuples' do
    let(:tuple) { Hypostasis::Tuple.new('sample','tuple',15) }
    let(:subject) { Hypostasis::Key.new("simple\\tuple\\#{tuple.to_s}") }

    it { subject[0].must_equal 'simple' }
    it { subject[1].must_equal 'tuple' }
    it { subject[2].must_be_instance_of Hypostasis::Tuple }
  end
end
