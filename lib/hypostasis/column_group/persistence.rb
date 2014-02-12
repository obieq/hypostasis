module Hypostasis::ColumnGroup
  module Persistence
    extend ActiveSupport::Concern

    def save
      generate_id
      self.class.namespace.transact do |tr|
        #tr.set(self.class.namespace.for_column_group(self), true.to_s)
        @fields.each do |field_name, value|
          field_key = self.class.namespace.data_directory[self.class.to_s][self.id][field_name.to_s]
          field_value = self.class.namespace.serialize_messagepack(value)
          tr.set(field_key, field_value)
        end

        indexed_fields_to_commit.each do |key|
          tr.set(key, self.class.namespace.for_column_group(self).key)
        end
      end
      self
    end

    def destroy
      range = self.class.namespace.data_directory[self.class.to_s][self.id].range
      self.class.namespace.transact do |tr|
        tr.clear_range(range[0], range[1])
        #tr.clear_range_start_with(self.class.namespace.for_column_group(self))
        indexed_fields_to_commit.each {|key| tr.clear(key)}
      end
    end

    module ClassMethods
      def create(*attributes)
        self.new(*attributes).save
      end
    end
  end
end
