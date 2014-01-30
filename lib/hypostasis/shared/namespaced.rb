module Hypostasis::Shared
  module Namespaced
    extend ActiveSupport::Concern

    module ClassMethods
      def use_namespace(namespace)
        self.class_eval do
          class_variable_set(:@@namespace, Hypostasis::Namespace.new(namespace.to_s, detect_data_model))
        end
      end

      def namespace
        self.class_eval { class_variable_get(:@@namespace) }
      end

      private

      def detect_data_model
        if self.included_modules.include?(Hypostasis::ColumnGroup)
          :column_group
        elsif self.included_modules.include?(Hypostasis::Document)
          :document
        else
          :key_value
        end
      end
    end
  end
end
