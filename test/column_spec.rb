require 'minitest_helper'

describe Hypostasis::ColumnFamily do
  let(:subject) { SampleFamily.new(name: 'Frank', age: 25, dob: Date.today.prev_year(25)) }

  before do
    Hypostasis::Connection.create_namespace 'sample_families', data_model: :column_family
  end

  after do
    Hypostasis::Connection.destroy_namespace 'sample_families'
  end

  it { subject.must_respond_to :name }
  it { subject.must_respond_to :age }
  it { subject.must_respond_to :dob }

  it { subject.must_respond_to :name= }
  it { subject.must_respond_to :age= }
  it { subject.must_respond_to :dob= }

  it { subject.name.must_equal 'Frank' }
  it { subject.age.must_equal 25 }
  it { subject.dob.must_equal Date.today.prev_year(25) }

  it { subject.must_respond_to :save }
end
