module Hypostasis::Document
  module Findable
    extend ActiveSupport::Concern

    module ClassMethods
      def find(id)
        document_keys = []
        namespace.transact do |tr|
          document_keys = tr.get_range_start_with(namespace.for_document(self, id))
        end
        #raise Hypostasis::Errors::DocumentNotFound if document_keys.empty?
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

      #def find_where(field_value_pairs)
      #  results = {}
      #  namespace.transact do |tr|
      #    field_value_pairs.each do |field_name, value|
      #      index_path = Hypostasis::Tuple.new('indexes', self.to_s).to_s
      #      value = value.to_s unless value.is_a?(Fixnum) || value.is_a?(Bignum)
      #      field_path = Hypostasis::Tuple.new(field_name.to_s, value).to_s
      #      results[field_name] = tr.get_range_start_with(name.to_s + '\\' + index_path + '\\' + field_path)
      #    end
      #  end
      #
      #  if field_value_pairs.size > 1
      #    # Handle multiple field-value pairs
      #  end
      #
      #  final_results = []
      #  results.each_value do |keys|
      #    keys.each do |key|
      #      final_results << find(Hypostasis::Tuple.unpack(key.key.split('\\').last).to_a.last)
      #    end
      #  end
      #
      #  final_results
      #end
    end
  end
end
