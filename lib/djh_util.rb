# encoding: utf-8

# TODO 1: organize, possibly like AS
#       require  'djh_util/all'
#   or  require  'djh_util/extensions'
require 'active_support/concern'

Kernel.module_eval{ include DjhUtil::Extensions::Kernel }
Hash.class_eval{    include DjhUtil::Extensions::Hash }

