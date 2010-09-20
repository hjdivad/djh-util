# encoding: utf-8

# TODO 2: organize, possibly like AS
#       require  'djh_util/all'
#   or  require  'djh_util/extensions'
require 'active_support/concern'
require 'active_support/dependencies'

__DIR__ = File.dirname( __FILE__ )

ActiveSupport::Dependencies.autoload_paths << __DIR__ unless
  ActiveSupport::Dependencies.autoload_paths.include? __DIR__

module DjhUtil
end

Kernel.module_eval{ include DjhUtil::Extensions::Kernel }
Hash.class_eval{    include DjhUtil::Extensions::Hash }

