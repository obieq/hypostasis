module Hypostasis::Shared
  module HasMany
    extend ActiveSupport::Concern

    module ClassMethods
      def has_many(klass)
        singular_klass = klass.to_s.singularize
        accessor_name = klass.to_s
        child_klass = singular_klass.to_s.classify
        self_klass = "#{self.to_s.underscore}_id".to_sym
        self.class_eval do
          define_method(accessor_name) { child_klass.constantize.find_where(self_klass => @id) }
        end
      end
    end
  end
end
