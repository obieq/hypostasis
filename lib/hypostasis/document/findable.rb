module Hypostasis::Document
  module Findable
    extend ActiveSupport::Concern

    module ClassMethods
      def find(id)
        document_keys = []
        namespace.transact do |tr|
          document_keys = tr.get_range_start_with(namespace.for_document(self, id)).to_a
        end
        raise Hypostasis::Errors::DocumentNotFound if document_keys.empty?
        attributes = {}
        id = Hypostasis::Tuple.unpack(document_keys.first.key.split('\\')[1]).to_a[1]
        document_keys.each do |key|
          attribute_tuple = key.key.split('\\')[2]
          next if attribute_tuple.nil?
          unpacked_key = Hypostasis::Tuple.unpack(attribute_tuple)
          raw_value = key.value
          attributes[unpacked_key.to_a[0].to_sym] = reconstitute_value(unpacked_key, raw_value)
        end
        document = self.new(attributes)
        document.set_id(id)
        document
      end

      def find_where(field_value_pairs)
        results = []
        namespace.transact do |tr|
          field_value_pairs.each do |field, value|
            results << tr.get_range_start_with(namespace.for_index(self, field, value)).to_a
          end
        end
        results.flatten!
        results.collect! {|result| Hypostasis::Tuple.unpack(result.key.split('\\').last).to_a.last }.compact!
        results.select! {|e| results.count(e) == field_value_pairs.size}
        results.uniq!
        results.collect! {|result| find(result) }
      end
    end
  end
end
