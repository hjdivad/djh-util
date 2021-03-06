# encoding: utf-8

#TODO 2: organize
require 'active_support/concern'
require 'djh_util'

module DjhUtil; end
module DjhUtil::Development; end
module DjhUtil::Development::Introspection; end


module DjhUtil::Development::Introspection::Object
  extend ActiveSupport::Concern

  included do
    alias_method  :ie,  :instance_eval
    alias_method  :moi, :methods_of_interest
  end

  module InstanceMethods
    def methods_of_interest search_dist=1
      total     = []
      order     = []
      self.class.ancestors.reverse.inject( {} ) do |moi_hash, klass|
        moi_hash[ klass ] = (klass.instance_methods - total).sort
        total             += moi_hash[ klass ]
        order.unshift     klass

        moi_hash
      end.select{ |k,v| order.take( search_dist ).include? k }
    end

    def mg  *args, &block
      methods.grep    *args, &block
    end

    def eigenclass
      class << self; self; end
    end
  end
end
Object.class_eval{ include DjhUtil::Development::Introspection::Object }


module DjhUtil::Development::Introspection::Module
  extend ActiveSupport::Concern

  included do
    alias_method  :ce,      :class_eval
    alias_method  :imoi,    :instance_methods_of_interest
  end

  module InstanceMethods
    def instance_methods_of_interest
      (instance_methods - Module.instance_methods).sort
    end

    def img *args, &block
      instance_methods_of_interest.grep *args, &block
    end
  end
end
Module.class_eval{ include DjhUtil::Development::Introspection::Module }
