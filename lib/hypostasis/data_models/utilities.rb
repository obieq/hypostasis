module Hypostasis::DataModels::Utilities
  private

  def get_class_name(object)
    object.is_a?(Class) ? object.to_s : object.class.to_s
  end

  def get_object_id(object, id = nil)
    id.nil? ? object.id.to_s : id.to_s
  end
end
