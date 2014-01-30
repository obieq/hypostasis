module Hypostasis::Document
  module Findable
    extend ActiveSupport::Concern

    module ClassMethods
      def find(id)
        fdb_key = nil
        namespace.transact do |tr|
          fdb_key = tr.get(namespace.for_document(self, id))
        end
        raise Hypostasis::Errors::DocumentNotFound if fdb_key.nil?
        reconstitute_document(fdb_key.value, id)
      end

      private

      def reconstitute_document(bson_value, id)
        document = self.new(Hash.from_bson(StringIO.new(bson_value)))
        document.set_id(id)
        document
      end
    end
  end
end
