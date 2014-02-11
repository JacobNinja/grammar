require 'ripper'

module Grammar

  class Parser < Ripper

    PARSER_EVENT_TABLE.each do |event, arity|
      if /_new\z/ =~ event.to_s and arity == 0
        define_method :"on_#{event}" do
          []
        end
      elsif /_add\z/ =~ event.to_s
        define_method :"on_#{event}" do |list, item|
          list.tap do |l|
            l << item
          end
        end
      else
        define_method :"on_#{event}" do |*args|
          raise MalformedExpression
        end
      end
    end

    SCANNER_EVENTS.each do |event|
      define_method :"on_#{event}" do |*|
        raise MalformedExpression
      end
    end

    [:nl, :lparen, :rparen, :period, :comma, :paren, :void_stmt, :sp].each do |event|
      define_method :"on_#{event}" do |*|
        []
      end
    end

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

    def on_parse_error(*)
      raise SyntaxError
    end

    def compile_error(*)
      raise SyntaxError
    end

  end

end