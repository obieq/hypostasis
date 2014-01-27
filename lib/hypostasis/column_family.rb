require 'active_support/concern'

require 'hypostasis/shared/namespaced'
require 'hypostasis/shared/fields'

require 'hypostasis/column_family/persistence'

module Hypostasis::ColumnFamily
  extend ActiveSupport::Concern

  include Hypostasis::Shared::Namespaced
  include Hypostasis::Shared::Fields

  include Hypostasis::ColumnFamily::Persistence

  def initialize(*attributes)
    self.class.namespace.open

    @fields = {}
    self.class.fields.each {|name| @fields[name] = nil}
    attributes.each {|hsh| hsh.each {|name, value| @fields[name.to_sym] = value}}
  end

  module ClassMethods
    include Hypostasis::DataModels::Utilities
  end
end
