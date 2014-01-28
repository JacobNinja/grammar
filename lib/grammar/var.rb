module Grammar

  Var = Struct.new(:token) do

    def name
      self.token.name
    end

    def resolve(env)
      env[self.token.name]
    end

    def push(var)
      NestedVar.new(self.token, var)
    end

  end

end