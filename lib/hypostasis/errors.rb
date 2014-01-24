module Hypostasis::Errors
  class NamespaceAlreadyCreated < StandardError; end
  class NonExistentNamespace < StandardError; end
  class CanNotReadNamespaceConfig < StandardError; end
  class UnknownNamespaceDataModel < StandardError; end
  class NamespaceDataModelMismatch < StandardError; end
  class InvalidKeyPath < StandardError; end
  class KeyPathExhausted < StandardError; end
  class InvalidTuple < StandardError; end
  class TupleExhausted < StandardError; end
  class UnknownValueType < StandardError; end
  class MustDefineFieldType < StandardError; end
end
