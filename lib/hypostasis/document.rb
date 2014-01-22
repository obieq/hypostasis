module Hypostasis::Document
  def self.included(base)
    base.extend ClassMethods
    base.class_eval do
      attr_reader :id
      # Register somewhere?
    end
  end

  def initialize(*attributes)
    self.class.namespace.open

    @fields = {}
    self.class.fields.each {|name| @fields[name] = nil}
    attributes.each {|hsh| hsh.each {|name, value| @fields[name.to_sym] = value}}
  end

  def save
    generate_id
    self.class.namespace.transact do |tr|
      tr.set(self.class.namespace.for_document(self), true.to_s)

      @fields.each do |field_name, value|
        tr.set(self.class.namespace.for_field(self, field_name, value.class.to_s), value.to_s)
      end
    end
    self
  end

  def generate_id
    @id ||= SecureRandom.uuid
  end

  module ClassMethods
    def use_namespace(namespace)
      @@namespace = Hypostasis::Namespace.new(namespace.to_s, :document)
    end

    def namespace
      @@namespace
    end

    def supported_field_types
      @@supported_field_types ||= %w{Fixnum Bignum String Integer Float Date DateTime Time Boolean}
    end

    def field(name, options = {})
      named = name.to_s
      raise Hypostasis::Errors::MustDefineFieldType if options[:type].nil?
      raise Hypostasis::Errors::UnsupportedFieldType unless supported_field_types.include?(options[:type].to_s)
      register_field(name.to_sym)
      create_accessors(named, options)
    end

    def fields
      @@fields
    end

    def register_field(name)
      @@fields = [] unless defined?(@@fields)
      @@fields << name.to_sym
    end

    def create_accessors(name, options)
      self.class_eval do
        define_method(name) { @fields[name.to_sym] || nil }
        define_method("#{name}=") {|value| @fields[name.to_sym] = value}
      end
    end

    def find(id)
      namespace.transact do |tr|
        document_keys = tr.get_range_start_with(namespace.for_document(self, id))
      end

      # Actually process the keys
    end
  end
end
