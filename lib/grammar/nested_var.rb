module Grammar

  class NestedVar

    attr_reader :vars

    def initialize(*vars)
      @vars = vars
    end

    def resolve(env)
      @vars.reduce(env) do |e, var|
        e[var.name]
      end
    end

    def push(var)
      NestedVar.new(*@vars, var)
    end

    def ==(other)
      @vars == other.vars
    end

  end

end