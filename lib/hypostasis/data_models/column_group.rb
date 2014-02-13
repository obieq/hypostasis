module Hypostasis::DataModels::ColumnGroup
  def transact
    database.transact do |tr|
      yield tr
    end
  end
end
