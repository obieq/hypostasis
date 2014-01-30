module Hypostasis::ColumnGroup
  module Namespaced
    extend ActiveSupport::Concern

    module ClassMethods
      def use_namespace(namespace)
        data_model = :key_value
        data_model = :column_group if self.included_modules.include?(Hypostasis::ColumnGroup)
        self.class_eval do
          class_variable_set(:@@namespace, Hypostasis::Namespace.new(namespace.to_s, data_model))
        end
      end

      def namespace
        self.class_eval { class_variable_get(:@@namespace) }
      end
    end
  end
end
