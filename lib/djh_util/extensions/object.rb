module DjhUtil::Extensions::Object
  extend ActiveSupport::Concern

  module InstanceMethods
    # Deep duplicate via remarshaling.  Not always applicable.
    def ddup
        Marshal.load( Marshal.dump( self ))
    end
  end
end
