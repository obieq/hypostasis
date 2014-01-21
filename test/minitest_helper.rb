if ENV['CI']
  require 'codeclimate-test-reporter'
  CodeClimate::TestReporter.start
else
  require 'simplecov'
  SimpleCov.start do
    add_filter '/test/'
  end
end

$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'hypostasis'

require 'minitest/autorun'

require 'support/sample_document'

class Minitest::Spec

  def database
    @database ||= FDB.open
  end

end
