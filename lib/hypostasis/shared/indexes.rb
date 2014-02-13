module Hypostasis::Shared
  module Indexes
    extend ActiveSupport::Concern

    included do
      cattr_accessor :indexed_fields
      self.class_eval <<-EOS
        @@indexed_fields = []
      EOS
    end

    private

    def indexed_fields_to_commit
      indexed_fields.collect do |field_name|
        field_value = self.class.namespace.serialize_messagepack(@fields[field_name])
        self.class.namespace.indexes_directory[self.class.to_s][field_name.to_s][field_value][self.id].key
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
