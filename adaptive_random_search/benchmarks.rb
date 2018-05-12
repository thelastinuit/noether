#!/usr/bin/env ruby
require "benchmark/ips"
require_relative "adaptive_random_search"

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
