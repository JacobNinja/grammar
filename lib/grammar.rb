require File.expand_path('../grammar/parser', __FILE__)
require File.expand_path('../grammar/var', __FILE__)
require File.expand_path('../grammar/function', __FILE__)
require File.expand_path('../grammar/nested_var', __FILE__)
require File.expand_path('../grammar/token', __FILE__)
require File.expand_path('../grammar/missing', __FILE__)
require File.expand_path('../grammar/result', __FILE__)

module Grammar

  def self.process(rb, env)
    Parser.parse(rb).resolve(env)
  end

end
