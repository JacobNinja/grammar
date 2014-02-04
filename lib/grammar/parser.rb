require 'ripper'

module Grammar

  class Parser < Ripper::SexpBuilderPP

    # Whole program AST; we only want the first node
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
      positional = args.first.to_a
      func.arguments(positional)
    end

    def on_ident(token)
      Token.new(token, lineno(), column())
    end

    def on_call(var, _, nested_var)
      var.push(nested_var)
    end

    # Arguments

    def on_arg_paren(*args)
      args.compact
    end

    def on_args_add_block(args, *b)
      args
    end

    # Parser error

    def compile_error(msg)
      # Ripper swallows this. Rethrow in Grammar::process
      raise Grammar::SyntaxError, msg
    end

  end

end