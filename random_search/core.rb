require "./space"

module RandomSearch
  class Core
    def initialize(config)
      @space = RandomSearch::Space.new config[:space]
      @iteration = config[:iteration]
      @result = nil
    end

    def best
      @iteration.times do |iter|
        candidate = { vector: vector, cost: cost }
        @result = candidate if @result.nil? || candidate[:cost] < @result[:cost]
        puts " > iteration = #{(iter + 1)}, best = #{@result[:cost]}" unless RandomSearch.configuration[:benchmarking]
      end

      @result
    end

    private

    def vector
      Array.new(@space.size) do |i|
        @space.row(i).column(0) + (@space.row(i).column(1) - @space.row(i).column(0)) * rand
      end
    end

    def cost
      vector.reduce(0) { |sum, element| sum + element**2.0 }
    end
  end
end
