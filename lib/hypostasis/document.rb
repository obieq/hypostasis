require 'hypostasis/shared'

module Hypostasis::Document
  extend ActiveSupport::Concern

  include Hypostasis::Shared
  include Hypostasis::Shared::Namespaced
  include Hypostasis::Shared::Fields
  include Hypostasis::Shared::Indexes
  include Hypostasis::Shared::Persistence
  include Hypostasis::Shared::Findable
  include Hypostasis::Shared::BelongsTo
  include Hypostasis::Shared::HasOne
  include Hypostasis::Shared::HasMany

  module ClassMethods; end
end
