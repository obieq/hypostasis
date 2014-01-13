module Hypostasis::Errors
  class NamespaceAlreadyCreated < StandardError; end
  class NonExistentNamespace < StandardError; end
  class InvalidKeyPath < StandardError; end
end
