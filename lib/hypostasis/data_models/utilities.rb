module Hypostasis::DataModels::Utilities
  private

  def get_class_name(object)
    object.is_a?(Class) ? object.to_s : object.class.to_s
  end

  def get_object_id(object, id = nil)
    id.nil? ? object.id.to_s : id.to_s
  end

  def reconstitute_value(tuple, raw_value)
    data_type = tuple.to_a.last
    case data_type
      when 'Fixnum'
        Integer(raw_value)
      when 'Bignum'
        Integer(raw_value)
      when 'Float'
        Float(raw_value)
      when 'String'
        raw_value
      when 'Date'
        Date.parse(raw_value)
      when 'DateTime'
        DateTime.parse(raw_value)
      when 'Time'
        Time.parse(raw_value)
      when 'TrueClass'
        true
      when 'FalseClass'
        false
      when 'NilClass'
        nil
      else
        raise Hypostasis::Errors::UnknownValueType
    end
  end

  def serialize_messagepack(value)
    begin
      serialized_value = value
      serialized_value = value.class.to_msgpack_type(value) if value.class.respond_to?(:to_msgpack_type)
      serialized_value.to_msgpack
    rescue StandardError
      raise Hypostasis::Errors::UnknownValueType, 'value can not be serialized to MessagePack'
    end
  end

  def deserialize_messagepack(value, klass)
    begin
      msgpack_value = MessagePack.unpack(StringIO.new(value))
      if klass.respond_to?(:from_msgpack_type)
        klass.from_msgpack_type(msgpack_value)
      else
        msgpack_value
      end
    rescue StandardError
      raise Hypostasis::Errors::UnknownValueType, 'value can not be deserialized from MessagePack'
    end
  end
end
