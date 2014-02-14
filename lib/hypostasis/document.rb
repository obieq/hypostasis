require 'hypostasis/shared'
require 'hypostasis/document/persistence'

module Hypostasis::Document
  extend ActiveSupport::Concern

  include Hypostasis::Shared
  include Hypostasis::Shared::Namespaced
  include Hypostasis::Shared::Fields
  include Hypostasis::Shared::Indexes
  include Hypostasis::Shared::Findable
  include Hypostasis::Shared::BelongsTo
  include Hypostasis::Shared::HasOne
  include Hypostasis::Shared::HasMany

  include Hypostasis::Document::Persistence

  module ClassMethods; end
end
