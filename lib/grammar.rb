require File.expand_path('../grammar/parser', __FILE__)
require File.expand_path('../grammar/var', __FILE__)
require File.expand_path('../grammar/function', __FILE__)
require File.expand_path('../grammar/nested_var', __FILE__)
require File.expand_path('../grammar/token', __FILE__)
require File.expand_path('../grammar/missing', __FILE__)
require File.expand_path('../grammar/result', __FILE__)

module Grammar

  MalformedExpression = Class.new(StandardError)
  SyntaxError = Class.new(StandardError)

  def self.process(rb, env)
    raise_conditions { Parser.parse(rb) }.resolve(env)
  end

  private

  def self.raise_conditions(&block)
    block.call.tap do |ast|
      raise SyntaxError if ast.nil?
      raise MalformedExpression unless ast.respond_to?(:resolve)
    end
  end

end
