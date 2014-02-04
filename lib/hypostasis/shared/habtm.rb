module Hypostasis::Shared
  module HABTM
    extend ActiveSupport::Concern

    module ClassMethods
      def has_and_belongs_to_many(klass)
        create_habtm_writers(klass.to_s)
        create_habtm_reader(klass.to_s)

        #self.class_eval do
        #  field field_name.to_sym
        #  index field_name.to_sym
        #end
      end

      private

      def create_habtm_writers(klass)
        define_method("#{klass}=") do |others|
          self.class.namespace.transact do |tr|
            others.each do |other|
              tr.set(self.class.namespace.for_index(self.class, klass, self.id) + "\\#{other.id}", 'true')
            end
          end
        end

        define_method("#{klass}<<") do |other|
          self.class.namespace.transact do |tr|
            tr.set(self.class.namespace.for_index(self.class, klass, self.id) + "\\#{other.id}", 'true')
          end
        end
      end

      def create_habtm_reader(klass)
        define_method(klass) do
          others = nil
          self.class.namespace.transact do |tr|
            others = tr.get_range_start_with(self.class.namespace.for_index(self.class, klass, self.id)).to_a
          end
          return [] if others.nil?
          others.collect! do |other|
            other_id = other.key.split('\\').last
            klass.singularize.classify.constantize.find(other_id)
          end
        end
      end
    end
  end
end
