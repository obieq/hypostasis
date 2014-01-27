module Hypostasis::Document
  module BelongsTo
    extend ActiveSupport::Concern

    module ClassMethods
      def belongs_to(klass)
        field_name = klass.to_s + '_id'
        register_field(field_name)

        parent_klass = klass.to_s.classify
        self.class_eval do
          define_method(klass.to_s) { parent_klass.constantize.find(@fields[field_name.to_sym].to_s) }
          define_method(field_name) { @fields[field_name.to_sym].to_s }

          class_variable_set(:@@indexed_fields, []) unless class_variable_defined?(:@@indexed_fields)
          registered_indexed_fields = class_variable_get(:@@indexed_fields)
          registered_indexed_fields << field_name.to_sym
          class_variable_set(:@@indexed_fields, registered_indexed_fields)
        end
      end
    end
  end
end
