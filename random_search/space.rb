module RandomSearch
  class Space
    def initialize(array)
      @array = array
      @row = nil
      @column = nil
    end

    def size
      @array.size
    end

    def row(value)
      raise "Nil values are not allowed." unless value
      @row = value
      return clean_and_return if @column
      self
    end

    def column(value)
      raise "Nil values are not allowed." unless value
      @column = value
      return clean_and_return if @row
      self
    end

    private

    def clean_and_return
      row = @row
      @row = nil
      column = @column
      @column = nil
      @array[row][column]
    end
  end
end
