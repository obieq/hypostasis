require 'active_support/concern'

require 'hypostasis/document/fields'
require 'hypostasis/document/indexes'
require 'hypostasis/document/persistence'
require 'hypostasis/document/findable'

module Hypostasis::Document
  extend ActiveSupport::Concern

  include Hypostasis::Document::Fields
  include Hypostasis::Document::Indexes
  include Hypostasis::Document::Persistence
  include Hypostasis::Document::Findable

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

    def use_namespace(namespace)
      @@namespace = Hypostasis::Namespace.new(namespace.to_s, :document)
    end

    def namespace
      @@namespace
    end

    def supported_field_types
      @@supported_field_types ||= %w{Fixnum Bignum String Integer Float Date DateTime Time Boolean}
    end
  end
end