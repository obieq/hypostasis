require 'active_support/concern'
require 'active_support/inflector'

require 'hypostasis/document/namespaced'
require 'hypostasis/document/fields'
require 'hypostasis/document/indexes'
require 'hypostasis/document/persistence'
require 'hypostasis/document/findable'
require 'hypostasis/document/belongs_to'
require 'hypostasis/document/has_one'

module Hypostasis::Document
  extend ActiveSupport::Concern

  include Hypostasis::Document::Namespaced
  include Hypostasis::Document::Fields
  include Hypostasis::Document::Indexes
  include Hypostasis::Document::Persistence
  include Hypostasis::Document::Findable

  include Hypostasis::Document::BelongsTo
  include Hypostasis::Document::HasOne

  attr_reader :id

  def initialize(*attributes)
    self.class.namespace.open

    @fields = {}
    self.class.fields.each {|name| @fields[name] = nil}
    attributes.each {|hsh| hsh.each {|name, value| @fields[name.to_sym] = value}}
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
