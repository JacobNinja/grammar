module Grammar

  class Function

    attr_reader :name, :args

    def initialize(name, args=[])
      @name = name
      @args = args
    end

    def arguments(new_args)
      self.class.new(@name, new_args)
    end

    def ==(other)
      @name == other.name
      @args == other.args
    end

  end

end