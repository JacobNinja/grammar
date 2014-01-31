module Grammar

  Var = Struct.new(:token) do

    def name
      self.token.name
    end

    def resolve(env)
      value = env[self.token.name]
      missing_vars = [self.token.name] if value.nil?
      Result.new(value, Missing.vars(missing_vars))
    end

    def push(var)
      NestedVar.new(self.token, var)
    end

  end

end