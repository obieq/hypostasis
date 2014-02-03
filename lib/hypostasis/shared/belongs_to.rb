module Hypostasis::Shared
  module BelongsTo
    extend ActiveSupport::Concern

    module ClassMethods
      def belongs_to(klass)
        field_name = "#{klass.to_s}_id"
        accessor_name = klass.to_s
        parent_klass = klass.to_s.classify
        self.class_eval do
          field field_name.to_sym
          index field_name.to_sym
          define_method(accessor_name) { parent_klass.constantize.find(self.send(field_name.to_sym)) }
        end
      end
    end
  end
end
