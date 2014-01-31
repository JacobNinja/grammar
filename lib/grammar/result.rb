module Grammar

  class Result

    attr_reader :value, :missing

    def initialize(value, missing=nil)
      @value = value
      @missing = missing
    end

    def missing?
      missing.missing?
    end

  end

end