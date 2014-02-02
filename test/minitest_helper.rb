unless ENV['CI']
  require 'simplecov'
  SimpleCov.start do
    add_filter '/test/'
  end
end

$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'hypostasis'

require 'active_support/core_ext'
require 'active_support/time_with_zone'

require 'minitest/autorun'

require 'support/sample_column'
require 'support/indexed_column'
require 'support/sample_document'
require 'support/indexed_document'

Time.zone = 'UTC'

class Minitest::Spec

  def database
    @database ||= FDB.open
  end

  def document_path(document)
    document_namespace = document.class.namespace.to_s
    document_tuple = Hypostasis::Tuple.new(document.class.to_s, document.id.to_s).to_s
    document_namespace + '\\' + document_tuple
  end

  def column_path(column_group)
    column_namespace = column_group.class.namespace.to_s
    column_tuple = Hypostasis::Tuple.new(column_group.class.to_s, column_group.id.to_s).to_s
    column_namespace + '\\' + column_tuple
  end

  def field_path(column_group, name, type)
    column_namespace = column_group.class.namespace.to_s
    column_tuple = Hypostasis::Tuple.new(column_group.class.to_s, column_group.id.to_s).to_s
    field_tuple = Hypostasis::Tuple.new(name.to_s, type.to_s).to_s
    column_namespace + '\\' + column_tuple + '\\' + field_tuple
  end

  def index_path(klass, field_name, value = nil)
    namespace = klass.namespace.to_s
    indexes_tuple = Hypostasis::Tuple.new('indexes', klass.to_s).to_s
    if value.nil?
      indexed_value_tuple = Hypostasis::Tuple.new(field_name.to_s).to_s
    else
      value = value.to_s unless value.is_a?(Fixnum) || value.is_a?(Bignum)
      indexed_value_tuple = Hypostasis::Tuple.new(field_name.to_s, value).to_s
    end
    namespace + '\\' + indexes_tuple + '\\' + indexed_value_tuple
  end

end
