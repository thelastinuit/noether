require_relative "space"
require_relative "factors"

module AdaptiveRandomSearch
  class Core
    def initialize(config)
      @space = AdaptiveRandomSearch::Space.new config[:space]
      @iteration = config[:iteration]
      @factors = AdaptiveRandomSearch::Factors.new config
      @maximum_improvement = config[:maximum_improvement]
      @iteration_multiplier = config[:iteration_multiplier]
    end

    def best
      step_size = (@space.row(0).colum(1) - @space.row(0).column(0)) * @factors.initial
      count = 0
      candidate = {}
      candidate[:vector] = vector
      candidate[:cost] = cost

      @iteration.times do |i|
        big_step_size = large_step_size i, step_size
        step = {}
        big_step = {}
        step[:vector] = take_step candidate[:vector], step_size
        step[:cost] = cost step[:vector]
        big_step[:vector] = take_step candidate[:vector], big_step_size
        big_step[:cost] = cost big_step[:vector]

        if step[:cost] <= candidate[:cost] || big_step[:cost] <= candidate[:cost]
          if big_step[:cost] <= step[:cost]
            step_size = big_step_size
            candidate = big_step
          else
            candidate = step
          end

          count = 0
        else
          count += 1
          if count >= @maximum_improvement
            count = 0
            step_size /= @factors.small
          end
        end

        puts " > iteration #{(i + 1)}, best = #{candidate[:cost]}" unless AdaptiveRandomSearch.configuration[:benchmarking]
      end

      candidate
    end

    private

    def vector(minimum = nil, maximum = nil)
      if minimum && maximum
        Array.new(@space.size) do
          minimum + (maximum - minimum) * rand
        end
      else
        Array.new(@space.size) do |i|
          @space.row(i).column(0) + (@space.row(i).column(1) - @space.row(i).column(0)) * rand
        end
      end
    end

    def cost(local_vector = [])
      return vector.reduce(0) { |sum, element| sum + element**2.0 } if local_vector.empty?

      local_vector.flatten.reduce(0) { |sum, element| sum + element**2.0 }
    end

    def take_step(current, step_size)
      position = Array.new(current.size)

      position.size.times do |i|
        minimum = [@space.row(i).column(0), current[i] - step_size].max
        maximum = [@space.row(i).column(1), current[i] + step_size].min
        position[i] = vector minimum, maximum
      end

      position
    end

    def large_step_size(i, step_size)
      return step_size * @factors.large if i.positive? && i.modulo(@iteration_multiplier).zero?

      step_size * @factors.small
    end
  end
end
