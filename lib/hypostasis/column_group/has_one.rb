module Hypostasis::ColumnGroup
  module HasOne
    extend ActiveSupport::Concern

    module ClassMethods
      def has_one(klass)
        accessor_name = klass.to_s
        child_klass = klass.to_s.classify
        self_klass = "#{self.to_s.underscore}_id".to_sym
        self.class_eval do
          define_method(accessor_name) { child_klass.constantize.find_where(self_klass => @id).first }
        end
      end
    end
  end
end
