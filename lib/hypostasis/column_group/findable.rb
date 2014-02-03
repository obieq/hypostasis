module Hypostasis::ColumnGroup
  module Findable
    extend ActiveSupport::Concern

    module ClassMethods
      def find(id)
        document_keys = namespace.transact do |tr|
          tr.get_range_start_with(namespace.for_column_group(self, id), {:streaming_mode => :want_all}).to_a
        end
        raise Hypostasis::Errors::ColumnGroupNotFound if document_keys.empty?
        reconstitute_column_group(document_keys)
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
        results.collect! {|result| find(result) }
      end

      private

      def reconstitute_column_group(keys)
        attributes = {}
        keys.each do |key|
          attribute_tuple = key.key.split('\\')[2]
          next if attribute_tuple.nil?
          unpacked_key = Hypostasis::Tuple.unpack(attribute_tuple)
          raw_value = key.value
          attributes[unpacked_key.to_a[0].to_sym] = reconstitute_value(unpacked_key, raw_value)
        end
        document = self.new(attributes)
        document.set_id(Hypostasis::Tuple.unpack(keys.first.key.split('\\')[1]).to_a[1])
        document
      end
    end
  end
end
