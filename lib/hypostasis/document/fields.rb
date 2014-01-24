module Hypostasis::Document
  module ClassMethods
    def field(name, options = {})
      register_field(name.to_sym)
      create_accessors(name.to_s, options)
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
  end
end
