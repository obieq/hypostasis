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

      def find_where(field_value_pairs)
        results = []
        namespace.transact do |tr|
          field_value_pairs.each do |field, value|
            results << tr.get_range_start_with(namespace.for_index(self, field, value), {:streaming_mode => :want_all}).to_a
          end
        end
        results.flatten!
        results.collect! {|result| Hypostasis::Tuple.unpack(result.key.split('\\').last).to_a.last }.compact!
        results.select! {|e| results.count(e) == field_value_pairs.size}
        results.uniq!
        find_many(results)
      end

      def find_many(ids)
        results = []
        namespace.transact do |tr|
          ids.each {|id| results << [tr.get(namespace.for_document(self, id)), id]}
        end
        results.collect! do |result|
          reconstitute_document(result[0], result[1])
        end
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
