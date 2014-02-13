module Hypostasis::DataModels::Document
  def transact
    database.transact do |tr|
      yield tr
    end
  end
end
