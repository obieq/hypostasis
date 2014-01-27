module Hypostasis::DataModels::ColumnFamily
  def transact
    database.transact do |tr|
      yield tr
    end
  end
end
