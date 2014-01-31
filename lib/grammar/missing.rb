module Grammar

  class Missing

    attr_reader :functions, :vars

    def initialize(functions: [], vars: [])
      @functions = functions
      @vars = vars
    end

    def self.vars(vs)
      vs ? new(vars: [vs]) : new
    end

    def missing?
      [@vars, @functions].any?(&:any?)
    end

    def merge(missing)
      missing && Missing.new(functions: missing.functions + functions, vars: missing.vars + vars) or self
    end

  end

end