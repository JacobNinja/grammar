module Grammar

  class Result

    attr_reader :missing

    def initialize(value_proc, missing=nil)
      @value_proc = value_proc
      @missing = missing
    end

    def missing?
      missing.missing?
    end

    def value
      @value_proc.call
    end

  end

end
