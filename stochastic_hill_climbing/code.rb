#!/usr/bin/env ruby
require "benchmark/ips"

module StochasticHillClimbing
  class << self
    def config(&block)
      @@configuration = {}

      class_eval &block
    end

    def process
      core = Core.new @@configuration
      core.best
    end

    def bits(value)
      @@configuration[:bits] = value
    end

    def iteration(value)
      @@configuration[:iteration] = value
    end

    class Core
      def initialize(config)
        @bits = config[:bits]
        @iteration = config[:iteration]
      end

      def best
        candidate = {}
        candidate[:vector] = bitstring
        candidate[:cost] = onemax candidate[:vector]

        @iteration.times do |i|
          neighbor = {}
          neighbor[:vector] = random_neighbor candidate[:vector]
          neighbor[:cost] = onemax neighbor[:vector]
          candidate = neighbor if neighbor[:cost] >= candidate[:cost]

          puts " > iteration #{i + 1}, best = #{candidate[:cost]}"
          break if candidate[:cost] == @bits
        end

        candidate
      end

      private

      def onemax(vector)
        vector.reduce(0.0) { |sum, v| sum + (v == "1" ? 1 : 0) }
      end

      def bitstring
        Array.new(@bits) { |_i| rand < 0.5 ? "1" : "0" }
      end

      def random_neighbor(bitstring)
        mutant = Array.new bitstring
        position = rand bitstring.size

        mutant[position] = mutant[position] == "1" ? "0" : "1"

        mutant
      end
    end
  end
end

Benchmark.ips do |x|
  x.report("small-random-search") do
    StochasticHillClimbing.config do
      bits 64
      iteration 100
    end

    best = StochasticHillClimbing.process

    puts "Done.\nBest Solution: \nc = #{best[:cost]}, \nv = #{best[:vector].inspect}"
  end

  x.report("big-random-search") do
    StochasticHillClimbing.config do
      bits 256
      iteration 100
    end

    best = StochasticHillClimbing.process

    puts "Done.\nBest Solution: \nc = #{best[:cost]}, \nv = #{best[:vector].inspect}"
  end

  x.compare!
end
