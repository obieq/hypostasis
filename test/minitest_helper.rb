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

class Minitest::Spec

  after do
    database.get_range_start_with("hypostasis\\config\\namespaces") do |kv|
      namespace = kv.key.gsub("hypostasis\\config\\namespaces\\", '')
      database.clear_range_start_with(namespace)
    end

    database.clear_range_start_with('hypostasis')
  end

private

  def database
    @database ||= FDB.open
  end

end
