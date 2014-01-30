require 'hypostasis/shared/namespaced'
require 'hypostasis/shared/fields'
require 'hypostasis/shared/indexes'

require 'hypostasis/column_group/persistence'
require 'hypostasis/column_group/findable'
require 'hypostasis/column_group/belongs_to'
require 'hypostasis/column_group/has_one'
require 'hypostasis/column_group/has_many'

module Hypostasis::ColumnGroup
  extend ActiveSupport::Concern

  include Hypostasis::Shared::Namespaced
  include Hypostasis::Shared::Fields
  include Hypostasis::Shared::Indexes

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
