module Hypostasis::Document
  module Persistence
    extend ActiveSupport::Concern

    def save
      generate_id
      self.class.namespace.transact do |tr|
        tr.set(self.class.namespace.for_document(self), self.to_bson)
        indexed_fields_to_commit.each {|key| tr.set(key, 'true') }
      end
      self
    end

    def destroy
      namespace.transact do |tr|
        tr.clear_range_start_with(namespace.for_document(self))
      end
    end

    module ClassMethods
      def create(*attributes)
        self.new(*attributes).save
      end
    end
  end
end
