module Hypostasis::ColumnGroup
  module Findable
    extend ActiveSupport::Concern

    module ClassMethods
      def find(id)
        range = namespace.data_directory[self.to_s][id.to_s].range
        document_keys = namespace.transact do |tr|
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
        keys.each do |key|
          key_name = namespace.data_directory.unpack(key.key)[2]
          key_value = namespace.deserialize_messagepack(key.value, registered_fields[key_name.to_sym][:type])
          reconstituted_attributes.merge!({key_name => key_value})
        end
        document = self.new(reconstituted_attributes)
        document.set_id(namespace.data_directory.unpack(keys.first.key)[1])
        document
      end
    end
  end
end
