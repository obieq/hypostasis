require 'minitest_helper'

describe Hypostasis::Tuple do
  let(:subject) { Hypostasis::Tuple.new('tuple', 'example', 123) }

  it { subject.must_respond_to :to_a }
  it { subject.must_respond_to :to_s }
  it { subject.must_respond_to :prepend }
  it { subject.must_respond_to :append }
  it { subject.must_respond_to :trim }

  it { subject.to_a.must_equal ['tuple', 'example', 123] }
  it { subject.to_s.must_equal "\x02tuple\x00\x02example\x00\x15{" }

  it { subject.prepend('another').is_a?(Hypostasis::Tuple).must_equal true }
  it { subject.prepend('another').to_a.must_equal ['another', 'tuple', 'example', 123] }

  it { subject.append('another').is_a?(Hypostasis::Tuple).must_equal true }
  it { subject.append('another').to_a.must_equal ['tuple', 'example', 123, 'another'] }

  it { subject.trim.must_equal subject }
  it { subject.trim(1).to_a.must_equal ['tuple', 'example'] }
  it { subject.trim(-1).to_a.must_equal ['example', 123] }
  it { lambda { subject.trim(3) }.must_raise Hypostasis::Errors::TupleExhausted }
  it { lambda { subject.trim(4) }.must_raise Hypostasis::Errors::TupleExhausted }
  it { lambda { subject.trim(-3) }.must_raise Hypostasis::Errors::TupleExhausted }
  it { lambda { subject.trim(-4) }.must_raise Hypostasis::Errors::TupleExhausted }

  it { lambda { Hypostasis::Tuple.new }.must_raise Hypostasis::Errors::InvalidTuple }

  it { Hypostasis::Tuple.unpack(subject.to_s).is_a?(Hypostasis::Tuple).must_equal true }
  it { Hypostasis::Tuple.unpack(subject.to_s).to_a.must_equal subject.to_a }

  it { subject.to_range.must_equal FDB::Tuple.range(subject.to_a) }
end
