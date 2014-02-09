module Hypostasis::ColumnGroup
  module Findable
    extend ActiveSupport::Concern

    module ClassMethods
      def find(id)
        document_keys = namespace.transact do |tr|
          range = namespace.for_column_group(self, id).range
          tr.get_range(range[0], range[1], {:streaming_mode => :want_all}).to_a
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

      def reconstitute_column_group(keys, id = nil)
        reconstituted_attributes = {}
        keys.each {|key| reconstituted_attributes = parse_key(key.key, key.value, reconstituted_attributes)}
        document = self.new(reconstituted_attributes)
        document.set_id(namespace.directory.unpack(keys.first.key)[1])
        document
      end

      def parse_key(key, value, reconstituted_attributes = {})
        attribute_name = namespace.directory.unpack(key).last
        return {} if attribute_name.nil? || registered_fields[attribute_name.to_sym].nil?
        reconstituted_value = namespace.deserialize_messagepack(value, registered_fields[attribute_name.to_sym][:type])
        reconstituted_attributes[attribute_name.to_sym] = reconstituted_value
        reconstituted_attributes
      end
    end
  end
end
