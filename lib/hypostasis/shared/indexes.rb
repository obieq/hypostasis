module Hypostasis::Shared
  module Indexes
    extend ActiveSupport::Concern


    included do
      cattr_accessor :indexed_fields
      self.class_eval <<-EOS
        @@indexed_fields = []
      EOS
    end
    #included do
    #  cattr_accessor_with_default :indexed_fields, []
    #end

    private

    def indexed_fields_to_commit
      indexed_fields.collect do |field_name|
        self.class.namespace.for_index(self, field_name, @fields[field_name])
      end
    end

    module ClassMethods
      def index(field_name, options = {})
        registered_indexed_fields = indexed_fields
        registered_indexed_fields << field_name.to_sym
        indexed_fields = registered_indexed_fields
      end
    end
  end
end
