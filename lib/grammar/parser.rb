require 'ripper'

module Grammar

  class Parser < Ripper::SexpBuilderPP

    def on_program(program)
      program.first
    end

    def on_fcall(token)
      Nodes::Function.new(token)
    end

    def on_vcall(token)
      Nodes::Var.new(token)
    end

    def on_method_add_arg(func, args)
      positional = args.first.to_a
      func.arguments(positional)
    end

    def on_ident(token)
      Token.new(token, lineno(), column())
    end

    def on_call(var, _, nested_var)
      Nodes::NestedVar.new(var.token, nested_var)
    end

    # Arguments

    def on_arg_paren(*args)
      args.compact
    end

    def on_args_add_block(args, *b)
      args
    end

  end

end