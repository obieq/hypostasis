module Hypostasis::Shared
  module Fields
    extend ActiveSupport::Concern

    included do
      cattr_accessor :registered_fields
      self.class_eval <<-EOS
        @@registered_fields = {}
      EOS
    end

    module ClassMethods
      def field(name, options = {})
        register_field(name.to_sym, options)
        create_accessors(name.to_s, options)
      end

      private

      def register_field(name, options = {})
        new_registered_fields = registered_fields
        new_registered_fields[name.to_sym] = options
        registered_fields = new_registered_fields
      end

      def create_accessors(name, options)
        self.class_eval do
          define_method(name) { @fields[name.to_sym] || nil }
          define_method("#{name}=") {|value| @fields[name.to_sym] = value}
        end
      end
    end
  end
end
