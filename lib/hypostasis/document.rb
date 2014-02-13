require 'hypostasis/shared'
require 'hypostasis/document/persistence'
require 'hypostasis/document/findable'

module Hypostasis::Document
  extend ActiveSupport::Concern

  include Hypostasis::Shared
  include Hypostasis::Shared::Namespaced
  include Hypostasis::Shared::Fields
  include Hypostasis::Shared::Indexes
  include Hypostasis::Shared::BelongsTo
  include Hypostasis::Shared::HasOne
  include Hypostasis::Shared::HasMany

  include Hypostasis::Document::Persistence
  include Hypostasis::Document::Findable

  module ClassMethods; end
end
