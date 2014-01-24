require 'active_support/concern'

require 'hypostasis/document/persistence'
require 'hypostasis/document/fields'

module Hypostasis::Document
  extend ActiveSupport::Concern

  include Hypostasis::Document::Persistence
  include Hypostasis::Document::Fields

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

    def find(id)
      document_keys = []
      namespace.transact do |tr|
        document_keys = tr.get_range_start_with(namespace.for_document(self, id))
      end
      #raise Hypostasis::Errors::DocumentNotFound if document_keys.empty?
      attributes = {}
      id = Hypostasis::Tuple.unpack(document_keys.first.key.split('\\')[1]).to_a[1]
      document_keys.each do |key|
        attribute_tuple = key.key.split('\\')[2]
        next if attribute_tuple.nil?
        unpacked_key = Hypostasis::Tuple.unpack(attribute_tuple)
        raw_value = key.value
        attributes[unpacked_key.to_a[0].to_sym] = reconstitute_value(unpacked_key, raw_value)
      end
      document = self.new(attributes)
      document.set_id(id)
      document
    end
  end
end
