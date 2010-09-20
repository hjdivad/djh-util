# encoding: utf-8

module DjhUtil::Extensions::Kernel
  extend ActiveSupport::Concern

  included do
    alias_method  :λ,  :lambda
  end
end
