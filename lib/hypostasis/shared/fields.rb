module Hypostasis::Shared
  module Fields
    extend ActiveSupport::Concern

    module ClassMethods
      def field(name, options = {})
        register_field(name.to_sym)
        create_accessors(name.to_s, options)
      end

      def fields
        self.class_eval { class_variable_get(:@@fields) }
      end

      private

      def register_field(name)
        self.class_eval do
          class_variable_set(:@@fields, []) unless class_variable_defined?(:@@fields)
          registered_fields = class_variable_get(:@@fields)
          registered_fields << name.to_sym
          class_variable_set(:@@fields, registered_fields)
        end
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
