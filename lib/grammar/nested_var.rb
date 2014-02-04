module Grammar

  class NestedVar

    attr_reader :vars

    def initialize(*vars)
      @vars = vars
    end

    def resolve(env, n=1)
      value = env[var_names[n - 1]]
      missing_vars = var_names.take(n) if value.nil?
      if missing_vars || n >= @vars.length
        Result.new(-> { value }, Missing.vars(missing_vars))
      else
        resolve(value, n.next)
      end
    end

    def push(var)
      NestedVar.new(*@vars, var)
    end

    def ==(other)
      @vars == other.vars
    end

    private

    def var_names
      @vars.map(&:name)
    end

  end

end
