module DjhUtil::MethodConflictResolution
  # TODO 1: only do this if necessary, i.e. if there IS a conflict
  # TODO 2: doc, note deficiencies
  #   - can't access class variables (could you normally?)
  def append_features base
    this = self
    sym = base.name && base.name.to_sym
    if ! base.anonymous? && base.parent.constants.include?( sym )
      case base
      when Class
        anon_module = Class.new base
        anon_module.class_eval do
          class << self
            alias_method :__superclass, :superclass
            def superclass
              __superclass.superclass
            end
            def ancestors
              ancestors = __superclass.ancestors
              ancestors.shift   # i.e. remove __superclass
              ancestors.unshift self
            end
          end

          include this
        end
      when Module
        anon_module = Module.new
        anon_module.module_eval do
          class << self
            def ancestors
              ancestors = super
              ancestors.shift 2
              ancestors.unshift self
              ancestors
            end
          end

          include this
          include base
        end
      end
      base.parent.const_set sym, anon_module
    else
      super
    end
  end
end
