module Hypostasis::Errors
  class NamespaceAlreadyCreated < StandardError; end
  class NonExistentNamespace < StandardError; end
  class InvalidKeyPath < StandardError; end
  class KeyPathExhausted < StandardError; end
end
