#!/usr/bin/env ruby

module RandomSearch
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

    class Core
      def initialize(config)
        @space = config[:space]
        @iteration = config[:iteration]
      end

      def vector
        Array.new(@space.size) do |i|
          @space[i][0] + (@space[i][1] - @space[i][0]) * rand
        end
      end

      def cost
        vector.inject(0) { |sum, element| sum + element ** 2.0 }
      end

      def best
        result = nil

        @iteration.times do |iter|
          candidate = {}
          candidate[:vector] = vector
          candidate[:cost] = cost

          result = candidate if result.nil? || candidate[:cost] < result[:cost]
          puts " > iteration = #{(iter + 1)}, best = #{result[:cost]}"
        end

        result
      end
    end
  end
end

RandomSearch.config do
  space Array.new(8) { |_i| [-5, +5] }
  iteration 100
end

best = RandomSearch.process

puts "Done.\nBest Solution: \nc = #{best[:cost]}, \nv = #{best[:vector].inspect}"
