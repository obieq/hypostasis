module Hypostasis::Shared
  module Findable
    extend ActiveSupport::Concern

    module ClassMethods
      def find(id)
        range = namespace.data_directory[self.to_s][id.to_s].range
        document_keys = namespace.transact do |tr|
          tr.get_range(range[0], range[1], {:streaming_mode => :want_all}).to_a
        end
        raise Hypostasis::Errors::ColumnGroupNotFound if document_keys.empty?
        reconstitute_from(document_keys)
      end

      def find_many(ids)
        results = []
        namespace.transact do |tr|
          ids.each do |id|
            range = namespace.data_directory[self.to_s][id.to_s].range
            results << tr.get_range(range[0], range[1])
          end
        end
        results.collect! {|result| reconstitute_from(result)}
      end

      def find_where(field_value_pairs)
        results = []
        namespace.transact do |tr|
          field_value_pairs.each do |field, value|
            range = namespace.indexes_directory[self.to_s][field.to_s][namespace.serialize_messagepack(value)].range
            results += tr.get_range(range[0], range[1]).to_a
          end
        end
        results.collect! {|result| namespace.indexes_directory.unpack(result.key).last }.compact!
        results.select! {|e| results.count(e) == field_value_pairs.size}
        results.uniq!
        find_many(results)
      end

      private

      def reconstitute_from(keys)
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
