require 'minitest_helper'

describe Hypostasis::KeyPath do
  let(:subject) { Hypostasis::KeyPath.new('hypostasis', 'demo', 'path') }

  it { lambda { Hypostasis::KeyPath.new }.must_raise Hypostasis::Errors::InvalidKeyPath }

  it { subject.to_s.must_equal 'hypostasis\demo\path' }
  it { subject.to_a.must_equal %w{hypostasis demo path} }

  describe '#extend_path' do
    it { subject.extend_path.must_equal subject }

    it { subject.extend_path('extension').to_s.must_equal 'hypostasis\demo\path\extension' }
    it { subject.extend_path('extension').to_a.must_equal %w{hypostasis demo path extension} }

    it { subject.extend_path('extension', 'path').to_s.must_equal 'hypostasis\demo\path\extension\path' }
    it { subject.extend_path('extension', 'path').to_a.must_equal %w{hypostasis demo path extension path} }
  end

  describe '#move_up' do
    it { subject.move_up.must_equal subject }
    it { subject.move_up(0).must_equal subject }
    it { subject.move_up(-1).must_equal subject }
    it { subject.move_up(-2).must_equal subject }

    it { subject.move_up(1).to_a.must_equal %w{hypostasis demo} }
    it { subject.move_up(2).to_a.must_equal %w{hypostasis} }
    it { lambda { subject.move_up(3) }.must_raise Hypostasis::Errors::KeyPathExhausted }
  end
end
