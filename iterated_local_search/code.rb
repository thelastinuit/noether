#!/usr/bin/env ruby
require "benchmark/ips"

module IteratedLocalSearch
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

    def maximum_improvements(value)
      @@configuration[:maximum_improvements] = value
    end

    class Core
      def initialize(config)
        @space = config[:space]
        @iteration = config[:iteration]
        @maximum_improvements = config[:maximum_improvements]
      end

      def best
        candidate = {}
        candidate[:vector] = random_permutation
        candidate[:cost] = cost candidate[:vector]
        candidate = local_search candidate

        @iteration.times do |i|
          current = perturbation candidate
          candidate = local_search candidate
          candidate = current if current[:cost] < candidate[:cost]

          puts " > iteration #{(i + 1)}, best = #{candidate[:cost]}"
        end

        candidate
      end

      private

      def random_permutation
        permutation = Array.new(@space.size) { |i| i }

        permutation.each_index do |i|
          r = rand(permutation.size - i) + i
          permutation[r], permutation[i] = permutation[i], permutation[r]
        end

        permutation
      end

      def perturbation(current)
        candidate = {}
        candidate[:vector] = double_bridge_move current[:vector]
        candidate[:cost] = cost candidate[:vector]

        candidate
      end

      def double_bridge_move(vector)
        first_position = 1 + rand(vector.size / 4)
        second_position = first_position + 1 + rand(vector.size / 4)
        third_position = second_position + 1 + rand(vector.size / 4)
        start_point = vector[0...first_position] + vector[third_position..vector.size]
        end_point = vector[second_position...third_position] + vector[first_position...second_position]

        start_point + end_point
      end

      def cost(vector)
        d = 0

        vector.each_with_index do |start_point, i|
          end_point = i == vector.size - 1 ? vector.first : vector[i + 1]
          d += distance @space[start_point], @space[end_point]
        end

        d
      end

      def local_search(current)
        count = 0

        begin
          candidate = {
            vector: local_optima(current[:vector])
          }
          candidate[:cost] = cost candidate[:vector]
          count = candidate[:cost] < current[:cost] ? 0 : count + 1
          current = candidate if candidate[:cost] < current[:cost]
        end until count >= @maximum_improvements

        current
      end

      def local_optima(vector)
        permutation = Array.new vector
        start_point = rand permutation.size
        end_point = rand permutation.size
        exclude = [start_point]
        exclude << start_point.zero? ? permutation.size - 1 : start_point - 1
        exclude << start_point == permutation.size - 1 ? 0 : start_point + 1
        end_point = rand(permutation.size) while exclude.include?(end_point)
        start_point, end_point = end_point, start_point if end_point < start_point
        permutation[start_point...end_point] = permutation[start_point...end_point].reverse

        permutation
      end

      def distance(start_point, end_point)
        Math.sqrt((start_point[0] - end_point[0])**2.0 + (start_point[1] - end_point[1])**2.0).round
      end
    end
  end
end

Benchmark.ips do |x|
  x.report("small-random-search") do
    IteratedLocalSearch.config do
      space [[565, 575], [25, 185], [345, 750], [945, 685], [845, 655],
             [880, 660], [25, 230], [525, 1000], [580, 1175], [650, 1130], [1605, 620],
             [1220, 580], [1465, 200], [1530, 5], [845, 680], [725, 370], [145, 665],
             [415, 635], [510, 875], [560, 365], [300, 465], [520, 585], [480, 415],
             [835, 625], [975, 580], [1215, 245], [1320, 315], [1250, 400], [660, 180],
             [410, 250], [420, 555], [575, 665], [1150, 1160], [700, 580], [685, 595],
             [685, 610], [770, 610], [795, 645], [720, 635], [760, 650], [475, 960],
             [95, 260], [875, 920], [700, 500], [555, 815], [830, 485], [1170, 65],
             [830, 610], [605, 625], [595, 360], [1340, 725], [1740, 245]]
      iteration 10
      maximum_improvements 50
    end

    best = IteratedLocalSearch.process

    puts "Done.\nBest Solution: \nc = #{best[:cost]}, \nv = #{best[:vector].inspect}"
  end

  x.report("big-random-search") do
    IteratedLocalSearch.config do
      space [[565, 575], [25, 185], [345, 750], [945, 685], [845, 655],
             [880, 660], [25, 230], [525, 1000], [580, 1175], [650, 1130], [1605, 620],
             [1220, 580], [1465, 200], [1530, 5], [845, 680], [725, 370], [145, 665],
             [415, 635], [510, 875], [560, 365], [300, 465], [520, 585], [480, 415],
             [835, 625], [975, 580], [1215, 245], [1320, 315], [1250, 400], [660, 180],
             [410, 250], [420, 555], [575, 665], [1150, 1160], [700, 580], [685, 595],
             [685, 610], [770, 610], [795, 645], [720, 635], [760, 650], [475, 960],
             [95, 260], [875, 920], [700, 500], [555, 815], [830, 485], [1170, 65],
             [830, 610], [605, 625], [595, 360], [1340, 725], [1740, 245]]
      iteration 30
      maximum_improvements 50
    end

    best = IteratedLocalSearch.process

    puts "Done.\nBest Solution: \nc = #{best[:cost]}, \nv = #{best[:vector].inspect}"
  end

  x.compare!
end
