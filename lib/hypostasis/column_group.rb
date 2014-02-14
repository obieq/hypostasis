require 'hypostasis/shared'
require 'hypostasis/column_group/persistence'

module Hypostasis::ColumnGroup
  extend ActiveSupport::Concern

  include Hypostasis::Shared
  include Hypostasis::Shared::Namespaced
  include Hypostasis::Shared::Fields
  include Hypostasis::Shared::Indexes
  include Hypostasis::Shared::Findable
  include Hypostasis::Shared::BelongsTo
  include Hypostasis::Shared::HasOne
  include Hypostasis::Shared::HasMany

  include Hypostasis::ColumnGroup::Persistence

  module ClassMethods; end
end
