require 'hypostasis/shared/namespaced'
require 'hypostasis/shared/fields'
require 'hypostasis/shared/indexes'
require 'hypostasis/shared/belongs_to'
require 'hypostasis/shared/has_one'
require 'hypostasis/shared/has_many'

module Hypostasis::Shared
  extend ActiveSupport::Concern

  attr_reader :id

  def initialize(*attributes)
    @fields = {}
    self.class.registered_fields.each {|name, options| @fields[name] = nil}
    attributes.each {|hsh| hsh.each {|name, value| @fields[name.to_sym] = value}}
    self
  end

  def generate_id
    @id ||= SecureRandom.uuid
  end

  def set_id(id)
    @id ||= id.to_s
  end

  module ClassMethods
    include Hypostasis::DataModels::Utilities
  end
end
