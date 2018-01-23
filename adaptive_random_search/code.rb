#!/usr/bin/env ruby
require "benchmark/ips"

module AdaptiveRandomSearch
  class << self
    def config(&block)
      @@configuration = {}

      class_eval &block
    end

    def process
      core = Core.new @@configuration
      core.best
    end

    def space(value)
      @@configuration[:space] = value
    end

    def iteration(value)
      @@configuration[:iteration] = value
    end

    def initial_factor(value)
      @@configuration[:initial_factor] = value
    end

    def small_factor(value)
      @@configuration[:small_factor] = value
    end

    def large_factor(value)
      @@configuration[:large_factor] = value
    end

    def iteration_multiplier(value)
      @@configuration[:iteration_multiplier] = value
    end

    def maximum_improvement(value)
      @@configuration[:maximum_improvement] = value
    end

    class Core
      def initialize(config)
        @space = config[:space]
        @iteration = config[:iteration]
        @initial_factor = config[:initial_factor]
        @small_factor = config[:small_factor]
        @large_factor = config[:large_factor]
        @maximum_improvement = config[:maximum_improvement]
        @iteration_multiplier = config[:iteration_multiplier]
      end

      def best
        step_size = (@space[0][1] - @space[0][0]) * @initial_factor
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
              step_size /= @small_factor
            end
          end

          puts " > iteration #{(i + 1)}, best = #{candidate[:cost]}"
        end

        candidate
      end

      private

      def vector(minimum = nil, maximum = nil)
        if minimum && maximum
          Array.new(@space.size) do |_i|
            minimum + (maximum - minimum) * rand
          end
        else
          Array.new(@space.size) do |i|
            @space[i][0] + (@space[i][1] - @space[i][0]) * rand
          end
        end
      end

      def cost(local_vector = [])
        if local_vector.empty?
          vector.reduce(0) { |sum, element| sum + element**2.0 }
        else
          local_vector.flatten.reduce(0) { |sum, element| sum + element**2.0 }
        end
      end

      def take_step(current, step_size)
        position = Array.new(current.size)

        position.size.times do |i|
          minimum = [@space[i][0], current[i] - step_size].max
          maximum = [@space[i][1], current[i] + step_size].min
          position[i] = vector minimum, maximum
        end

        position
      end

      def large_step_size(i, step_size)
        return step_size * @large_factor if i.positive? && i.modulo(@iteration_multiplier).zero?

        step_size * @small_factor
      end
    end
  end
end

Benchmark.ips do |x|
  x.report("small-random-search") do
    AdaptiveRandomSearch.config do
      space Array.new(8) { |_i| [-5, +5] }
      iteration 100
      initial_factor 0.05
      small_factor 1.3
      large_factor 3.0
      iteration_multiplier 10
      maximum_improvement 30
    end

    best = AdaptiveRandomSearch.process

    puts "Done.\nBest Solution: \nc = #{best[:cost]}, \nv = #{best[:vector].inspect}"
  end

  x.report("big-random-search") do
    AdaptiveRandomSearch.config do
      space Array.new(30) { |_i| [-5, +5] }
      iteration 100
      initial_factor 0.05
      small_factor 1.3
      large_factor 3.0
      iteration_multiplier 10
      maximum_improvement 30
    end

    best = AdaptiveRandomSearch.process

    puts "Done.\nBest Solution: \nc = #{best[:cost]}, \nv = #{best[:vector].inspect}"
  end

  x.compare!
end
