class Date
  def bson_type
    9.chr.force_encoding(BSON::BINARY).freeze
  end
end
