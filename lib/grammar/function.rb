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
      func = env[@token.name]
      args = @args.map { |arg| arg.resolve(env) }
      value = maybe_call_function(func, args)
      Result.new(value, missing(func, args))
    end

    def ==(other)
      @token == other.token
      @args == other.args
    end

    private

    def maybe_call_function(func, args)
      func.call(*args.map(&:value)) unless func.nil? || args.any?(&:missing?)
    end

    def missing(func, args)
      missing_functions = Missing.new(functions: Array(func.nil? ? @token.name : nil))
      args.map(&:missing).reduce(missing_functions, &:merge)
    end

  end

end