module Hypostasis::Shared
  module Namespaced
    extend ActiveSupport::Concern

    included do
      cattr_accessor :namespace
    end

    module ClassMethods
      def use_namespace(namespace_name)
        self.class_eval do
          class_variable_set :@@namespace, Hypostasis::Namespace.new(namespace_name.to_s, detect_data_model)
        end
      end

      private

      def detect_data_model
        if self.included_modules.include?(Hypostasis::ColumnGroup)
          :column_group
        elsif self.included_modules.include?(Hypostasis::Document)
          :document
        end
      end
    end
  end
end
