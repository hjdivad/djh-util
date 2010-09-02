module DjhUtil::Extensions::Hash
  extend ActiveSupport::Concern

  module InstanceMethods
    def reverse
      rv = {}
      self.each_pair do |key, value|
        raise "
          Duplicate value #{value}.  Calling Hash#reverse is only legal if the
          function induced by the hash is invertible.
        " if rv.has_key? value
        rv[ value ] = key
      end
      rv
    end
  end
end
