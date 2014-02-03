require 'hypostasis/shared/utilities'
require 'hypostasis/shared/namespaced'
require 'hypostasis/shared/fields'
require 'hypostasis/shared/indexes'

require 'hypostasis/document/persistence'
require 'hypostasis/document/findable'
require 'hypostasis/document/belongs_to'
require 'hypostasis/document/has_one'
require 'hypostasis/document/has_many'

module Hypostasis::Document
  extend ActiveSupport::Concern

  include Hypostasis::Shared::Utilities
  include Hypostasis::Shared::Namespaced
  include Hypostasis::Shared::Fields
  include Hypostasis::Shared::Indexes

  include Hypostasis::Document::Persistence
  include Hypostasis::Document::Findable
  include Hypostasis::Document::BelongsTo
  include Hypostasis::Document::HasOne
  include Hypostasis::Document::HasMany

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

  def to_bson
    @fields.to_bson
  end

  module ClassMethods
    include Hypostasis::DataModels::Utilities
  end
end
