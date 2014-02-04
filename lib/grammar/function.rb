module Grammar

  class Function

    attr_reader :token, :args

    def initialize(token, args=[])
      @token = token
      @args = args
    end

    def name
      token.name
    end

    def arguments(new_args)
      Function.new(@token, new_args)
    end

    def resolve(env)
      func = lookup(env, @token.name)
      args = @args.map { |arg| arg.resolve(env) }
      Result.new(function_proc(func, args), missing(func, args))
    end

    def ==(other)
      @token == other.token
      @args == other.args
    end

    private

    def function_proc(func, args)
      -> do
        func.call(*args.map(&:value)) unless func.nil? || args.any?(&:missing?)
      end
    end

    def missing(func, args)
      missing_functions = Missing.new(functions: Array(func.nil? ? @token.name : nil))
      args.map(&:missing).reduce(missing_functions, &:merge)
    end

    def lookup(env, func)
      (env['functions'] || {})[func]
    end

  end

end
