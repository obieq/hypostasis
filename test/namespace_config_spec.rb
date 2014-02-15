require 'minitest_helper'

describe Hypostasis::NamespaceConfig do
  let(:namespace) { Hypostasis::Namespace.create('demonstration') }
  let(:subject) { Hypostasis::NamespaceConfig.new(namespace, data_model: :key_value) }

  def config_path_for(key)
    FDB.directory.open(database, %w{demonstration config})[key.to_s]
  end

  before do
    subject
  end

  after do
    FDB.directory.remove_if_exists(database, %w{demonstration})
  end

  it { database.get(config_path_for :data_model).must_equal 'key_value'.to_msgpack }

  describe '#[]' do
    it { subject[:data_model].must_equal :key_value }
  end

  describe '#[]=' do
    before do
      subject[:sample] = :test
    end

    it { subject[:sample].must_equal :test }
    it { database.get(config_path_for :sample).must_equal 'test'.to_msgpack }
  end
end