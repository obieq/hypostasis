module Hypostasis::Shared
  module Indexes
    extend ActiveSupport::Concern

    private

    def indexed_fields_to_commit
      self.class.class_eval { class_variable_set(:@@indexed_fields, []) unless class_variable_defined?(:@@indexed_fields) }
      self.class.indexed_fields.collect do |field_name|
        self.class.namespace.for_index(self, field_name, @fields[field_name])
      end
    end

    module ClassMethods
      def index(field_name, options = {})
        self.class_eval do
          class_variable_set(:@@indexed_fields, []) unless class_variable_defined?(:@@indexed_fields)
          registered_indexed_fields = class_variable_get(:@@indexed_fields)
          registered_indexed_fields << field_name.to_sym
          class_variable_set(:@@indexed_fields, registered_indexed_fields)
        end
      end

      def indexed_fields
        self.class_eval { class_variable_get(:@@indexed_fields) }
      end
    end
  end
end
