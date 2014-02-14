module Hypostasis::Shared
  module Persistence
    extend ActiveSupport::Concern

    def save
      generate_id
      self.class.namespace.transact do |tr|
        @fields.each {|field_name, value| tr.set(field_key(field_name), field_value(value))}
        indexed_fields_to_commit.each {|key| tr.set(key, index_value)}
      end
      self
    end

    def destroy
      range = self.class.namespace.data_directory[self.class.to_s][self.id].range
      self.class.namespace.transact do |tr|
        tr.clear_range(range[0], range[1])
        indexed_fields_to_commit.each {|key| tr.clear(key)}
      end
    end

    private

    def field_key(field_name)
      self.class.namespace.data_directory[self.class.to_s][self.id][field_name.to_s]
    end

    def field_value(raw_value)
      self.class.namespace.serialize_messagepack(raw_value)
    end

    def index_value
      self.class.namespace.data_directory[self.class.to_s][self.id].to_s
    end

    module ClassMethods
      def create(*attributes)
        self.new(*attributes).save
      end
    end
  end
end
