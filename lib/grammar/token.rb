module Grammar

  class Token

    attr_reader :line

    def initialize(name, line=nil, column=nil)
      @name = name
      @line = line
      @column = column
    end

    def name
      @name[strip_count..-1]
    end

    def column
      @column + strip_count
    end

    def ==(other)
      name == other.name
      @line == other.line
      column == other.column
    end

    private

    def strip_count
      @name.scan(/\s+\./).map(&:length).first.to_i
    end

  end

end