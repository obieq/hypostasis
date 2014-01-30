require 'minitest_helper'

describe Hypostasis::Namespace do
  let(:subject) { Hypostasis::Namespace.new('demonstration') }

  it { subject.must_respond_to :name }
  it { subject.name.must_equal 'demonstration' }

  it { subject.must_respond_to :data_model }
  it { subject.data_model.must_equal :key_value }

  it { subject.must_respond_to :destroy }

  describe '#destroy' do
    before do
      Hypostasis::Connection.destroy_namespace('destroy_demo')
    end

    it {
      ns = Hypostasis::Namespace.create('destroy_demo')
      database.get('destroy_demo').must_equal 'true'
      ns.destroy
      database.get('destroy_demo').nil?.must_equal true
    }
  end

  describe 'for a Key-Value namespace' do
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

      it { database.get('keyvalue_space\\' + Hypostasis::Tuple.new('fixnum'.to_s, Fixnum.to_s).to_s).must_equal '5' }
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

        it { subject.get('date').must_equal @date }
      end

      describe 'for DateTime' do
        before do
          @date = DateTime.now
          subject.set('datetime', @date)
        end

        it { subject.get('datetime').year.must_equal @date.year }
        it { subject.get('datetime').month.must_equal @date.month }
        it { subject.get('datetime').day.must_equal @date.day }
        it { subject.get('datetime').hour.must_equal @date.hour }
        it { subject.get('datetime').minute.must_equal @date.minute }
        it { subject.get('datetime').second.must_equal @date.second }
        it { subject.get('datetime').zone.must_equal @date.zone }
      end

      describe 'for Time' do
        before do
          @time = Time.now
          subject.set('time', @time)
        end

        it { subject.get('time').hour.must_equal @time.hour }
        it { subject.get('time').min.must_equal @time.min }
        it { subject.get('time').sec.must_equal @time.sec }
        it { subject.get('time').zone.must_equal @time.zone }
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
          database.set('keyvalue_space\\' + Hypostasis::Tuple.new('unknown'.to_s, Unknown.to_s).to_s, '1')
        end

        it { lambda { subject.get('unknown') }.must_raise Hypostasis::Errors::UnknownValueType }
      end
    end
  end

  describe 'for a ColumnGroup namespace' do
    before do
      subject
    end

    after do
      subject.destroy
    end

    let(:subject) { Hypostasis::Namespace.create('column_space', { data_model: :column_group }) }

    it { database.get('column_space\\' + Hypostasis::Tuple.new(['config','data_model']).to_s).must_equal 'column_group' }
  end

  describe 'for an unknown namespace type' do
    after do
      Hypostasis::Connection.destroy_namespace('unknown_space')
    end

    it { lambda { Hypostasis::Namespace.create('unknown_space', { data_model: :unknown }) }.must_raise Hypostasis::Errors::UnknownNamespaceDataModel }
    it {
      database.set('unknown_space', 'true')
      database.set('unknown_space\\' + Hypostasis::Tuple.new(['config','data_model']).to_s, 'unknown')

      lambda {
        Hypostasis::Namespace.open('unknown_space')
      }.must_raise Hypostasis::Errors::UnknownNamespaceDataModel
    }
  end
end
