module Hypostasis::Shared
  module Fields
    extend ActiveSupport::Concern

    included do
      cattr_accessor_with_default :fields, []
    end

    module ClassMethods
      def field(name, options = {})
        register_field(name.to_sym)
        create_accessors(name.to_s, options)
      end

      private

      def register_field(name)
        registered_fields = fields
        registered_fields << name.to_sym
        fields = registered_fields
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
