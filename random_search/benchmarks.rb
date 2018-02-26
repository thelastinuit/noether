#!/usr/bin/env ruby
require "benchmark/ips"
require "./random_search"

Benchmark.ips do |x|
  x.report("small-random-search") do
    RandomSearch.config do
      space Array.new(8) { |_i| [-5, +5] }
      iteration 100
      benchmarking? true
    end

    best = RandomSearch.process

    puts "Done.\nBest Solution: \nc = #{best[:cost]}, \nv = #{best[:vector].inspect}"
  end

  x.report("big-random-search") do
    RandomSearch.config do
      space Array.new(800) { |_i| [-5, +5] }
      iteration 100
      benchmarking? true
    end

    best = RandomSearch.process

    puts "Done.\nBest Solution: \nc = #{best[:cost]}, \nv = #{best[:vector].inspect}"
  end

  x.compare!
end
