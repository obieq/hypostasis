module Hypostasis::Shared
  module Utilities
    extend ActiveSupport::Concern

    module ClassMethods
      def cattr_accessor_with_default(name, default = nil)
        cattr_accessor name
        class_variable_set("@@#{name.to_s}".to_sym, default)
      end
    end
  end
end
