require 'hypostasis/shared'
require 'hypostasis/column_group/persistence'
require 'hypostasis/column_group/findable'

module Hypostasis::ColumnGroup
  extend ActiveSupport::Concern

  include Hypostasis::Shared
  include Hypostasis::Shared::Utilities
  include Hypostasis::Shared::Namespaced
  include Hypostasis::Shared::Fields
  include Hypostasis::Shared::Indexes
  include Hypostasis::Shared::BelongsTo
  include Hypostasis::Shared::HasOne
  include Hypostasis::Shared::HasMany
  include Hypostasis::Shared::HABTM

  include Hypostasis::ColumnGroup::Persistence
  include Hypostasis::ColumnGroup::Findable

  module ClassMethods; end
end
