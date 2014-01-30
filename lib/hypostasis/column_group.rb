require 'active_support/concern'
require 'active_support/inflector'

require 'hypostasis/column_group/namespaced'
require 'hypostasis/column_group/fields'
require 'hypostasis/column_group/indexes'
require 'hypostasis/column_group/persistence'
require 'hypostasis/column_group/findable'
require 'hypostasis/column_group/belongs_to'
require 'hypostasis/column_group/has_one'
require 'hypostasis/column_group/has_many'

module Hypostasis::ColumnGroup
  extend ActiveSupport::Concern

  include Hypostasis::ColumnGroup::Namespaced
  include Hypostasis::ColumnGroup::Fields
  include Hypostasis::ColumnGroup::Indexes
  include Hypostasis::ColumnGroup::Persistence
  include Hypostasis::ColumnGroup::Findable

  include Hypostasis::ColumnGroup::BelongsTo
  include Hypostasis::ColumnGroup::HasOne
  include Hypostasis::ColumnGroup::HasMany

  attr_reader :id

  def initialize(*attributes)
    self.class.namespace.open

    @fields = {}
    self.class.fields.each {|name| @fields[name] = nil}
    attributes.each {|hsh| hsh.each {|name, value| @fields[name.to_sym] = value}}
    self
  end

  def generate_id
    @id ||= SecureRandom.uuid
  end

  def set_id(id)
    @id ||= id.to_s
  end

  module ClassMethods
    include Hypostasis::DataModels::Utilities
  end
end
