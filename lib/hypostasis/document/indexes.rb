module Hypostasis::Document
  module Indexes
    extend ActiveSupport::Concern

    def indexed_fields_to_commit
      self.class.indexed_fields.collect do |field_name|
        self.class.namespace.for_index(self, field_name, @fields[field_name])
      end
    end

    module ClassMethods
      def index(field_name, options = {})
        @@indexed_fields = [] unless defined? @@indexed_fields
        @@indexed_fields << field_name.to_sym
      end

      def indexed_fields
        @@indexed_fields
      end
    end
  end
end
