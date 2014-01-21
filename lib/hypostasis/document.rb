module Hypostasis::Document
  def self.included(base)
    base.extend ClassMethods
    base.class_eval do
      # Register somewhere?
    end
  end

  def initialize(*attributes)
    self.class.namespace.open

    @fields = {}
    self.class.fields.each {|field_name| @fields[field_name] = nil}
    attributes.each {|hsh| hsh.each {|name, value| @fields[name.to_sym] = value}}
  end

  module ClassMethods
    def use_namespace(namespace)
      @@namespace = Hypostasis::Namespace.new(namespace.to_s, :document)
    end

    def namespace
      @@namespace
    end

    def field(name, options = {})
      named = name.to_s
      raise Hypostasis::Errors::MustDefineFieldType if options[:type].nil?
      register_field(name.to_sym)
      create_accessors(named, options)
    end

    def fields
      @@fields
    end

    def register_field(name)
      @@fields = [] unless defined?(@@fields)
      @@fields << name
    end

    def create_accessors(name, options)
      self.class_eval do
        define_method(name) { @fields[name.to_sym] || nil }
        define_method("#{name}=") {|value| @fields[name.to_sym] = value}
      end
    end
  end
end
