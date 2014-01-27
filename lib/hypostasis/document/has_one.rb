module Hypostasis::Document
  module HasOne
    extend ActiveSupport::Concern

    module ClassMethods
      def has_one(klass)
        register_field(klass.to_sym)
        child_klass = klass.to_s.classify
        self.class_eval do
          define_method(klass.to_s) { child_klass.constantize.find_where(klass.to_sym => @id).first }
        end
      end
    end
  end
end
