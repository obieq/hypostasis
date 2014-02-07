
describe Hypostasis::DataModels::KeyValue do
  before do
    subject
  end

  after do
    subject.destroy
  end

  let(:subject) { Hypostasis::Namespace.create('keyvalue_space', { data_model: :key_value }) }

  it { database.get('keyvalue_space\\' + Hypostasis::Tuple.new(['config','data_model']).to_s).must_equal 'key_value' }
  it { subject.must_respond_to :get }
  it { subject.must_respond_to :set }

  describe '#set' do
    before do
      subject.set('fixnum', 5)
    end

    it { database.get('keyvalue_space\\fixnum').must_equal 5.to_msgpack }
  end

  describe '#get' do
    describe 'for Fixnums' do
      before do
        subject.set('fixnum', 5)
      end

      it { subject.get('fixnum').must_equal 5 }
    end

    describe 'for Bignum' do
      before do
        subject.set('bignum', 12333333333333333333)
      end

      it { subject.get('bignum').must_equal 12333333333333333333 }
    end

    describe 'for Float' do
      before do
        subject.set('float', 1.2345)
      end

      it { subject.get('float').must_equal 1.2345 }
    end

    describe 'for String' do
      before do
        subject.set('string', 'a string')
      end

      it { subject.get('string').must_equal 'a string' }
    end

    describe 'for Date' do
      before do
        @date = Date.today
        subject.set('date', @date)
      end

      it { subject.get('date', Date).must_equal @date }
    end

    describe 'for DateTime' do
      before do
        @date = DateTime.now
        subject.set('datetime', @date)
      end

      it { subject.get('datetime', DateTime).year.must_equal @date.year }
      it { subject.get('datetime', DateTime).month.must_equal @date.month }
      it { subject.get('datetime', DateTime).day.must_equal @date.day }
      it { subject.get('datetime', DateTime).hour.must_equal @date.hour }
      it { subject.get('datetime', DateTime).minute.must_equal @date.minute }
      it { subject.get('datetime', DateTime).second.must_equal @date.second }
      it { subject.get('datetime', DateTime).zone.must_equal @date.zone }
    end

    describe 'for Time' do
      before do
        @time = Time.now
        subject.set('time', @time)
      end

      it { subject.get('time', Time).hour.must_equal @time.hour }
      it { subject.get('time', Time).min.must_equal @time.min }
      it { subject.get('time', Time).sec.must_equal @time.sec }
      it { subject.get('time', Time).zone.must_equal @time.zone }

    end

    describe 'for Bolean' do
      before do
        subject.set('true', true)
        subject.set('false', false)
      end

      it { subject.get('true').must_equal true }
      it { subject.get('false').must_equal false }
    end

    describe 'for unknown type' do
      before do
        class Unknown; end
        database.set('keyvalue_space\\unknown', '\xunknown')
      end

      it { lambda { subject.set('unknown', Unknown.new) }.must_raise Hypostasis::Errors::UnknownValueType }
      it { lambda { subject.get('unknown') }.must_raise Hypostasis::Errors::UnknownValueType }
    end
  end
end
