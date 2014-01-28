require 'ripper'

module Grammar

  class Parser < Ripper::SexpBuilderPP

    def on_program(program)
      program.first
    end

    def on_fcall(token)
      Function.new(token)
    end

    def on_vcall(token)
      Var.new(token)
    end

    def on_method_add_arg(func, args)
      func.arguments(args)
    end

    def on_ident(token)
      Token.new(token, lineno(), column())
    end

    def on_arg_paren(*args)
      []
    end

  end

end