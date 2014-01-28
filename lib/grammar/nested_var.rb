module Grammar

  class NestedVar

    def initialize(*vars)
      @vars = vars
    end

    def resolve(env)
      @vars.reduce(env) do |e, var|
        e[var.name]
      end
    end

  end

end