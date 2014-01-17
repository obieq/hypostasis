require 'minitest_helper'

describe Hypostasis::Database do
  describe 'document database' do
    let(:subject) { Hypostasis::Database.open('docs', :document) }

    it { database.get(FDB::Tuple.pack(['docs', 'config', 'type', :document.to_s])).must_equal '' }
    it { database.get(FDB::Tuple.pack(['docs', 'config', 'version', 1])).must_equal '' }
  end
end
