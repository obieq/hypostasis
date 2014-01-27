module Hypostasis::ColumnFamily
  module Persistence
    extend ActiveSupport::Concern

    def save
      #self.class.namespace.transact do |tr|
      #  tr.set(self.class.namespace.for_document(self), true.to_s)
      #
      #  @fields.each do |field_name, value|
      #    tr.set(self.class.namespace.for_field(self, field_name, value.class.to_s), value.to_s)
      #  end
      #
      #  indexed_fields_to_commit.each do |key|
      #    tr.set(key, 'true')
      #  end
      #end
      self
    end

    def destroy
      #self.class.namespace.transact do |tr|
      #  tr.clear_range_start_with(self.class.namespace.for_document(self))
      #end
    end

    module ClassMethods
      #def create(*attributes)
      #  self.new(*attributes).save
      #end
    end
  end
end
