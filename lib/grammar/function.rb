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
      env[@token.name].call(*resolve_args(env))
    end

    def ==(other)
      @token == other.token
      @args == other.args
    end

    private

    def resolve_args(env)
      @args.map do |arg|
        case arg
          when Function then arg.resolve(env)
          else arg.resolve(env)
        end
      end
    end

  end

end