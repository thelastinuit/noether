#!/usr/bin/env ruby
require "benchmark/ips"

module GuidedLocalSearch
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

    def alpha(value)
      @@configuration[:alpha] = value
    end

    def optima(value)
      @@configuration[:optima] = value
    end

    class Core
      def initialize(config)
        @space = config[:space]
        @iteration = config[:iteration]
        @maximum_improvements = config[:maximum_improvements]
        @alpha = config[:alpha]
        @optima = config[:optima]
        @lambda = 1.0 * @alpha * @optima / @space.size
      end

      def best
        current = {}
        current[:vector] = random_permutation
        best = nil
        penalties = Array.new(@space.size) { Array.new(@space.size, 0) }

        @iteration.times do |i|
          current = local_search current, penalties
          utilities = calculate_feature_utilities penalties, current[:vector]
          update_penalties! penalties, current[:vector], utilities
          best = current if best.nil? || current[:cost] < best[:cost]

          puts " > iter = #{(i + 1)}, best = #{best[:cost]}, aug = #{best[:aug_cost]}"
        end

        best
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

      def cost(current, penalties)
        cost, acost = augmented_cost current[:vector], penalties
        current[:cost] = cost
        current[:aug_cost] = acost
      end

      def augmented_cost(permutation, penalties)
        d = 0
        augmented = 0

        permutation.each_with_index do |start_point, i|
          end_point = i == permutation.size - 1 ? permutation[0] : permutation[i + 1]
          start_point, end_point = end_point, start_point if end_point < start_point
          current_distance = distance @space[start_point], @space[end_point]
          d += current_distance
          augmented += current_distance + (@lambda * (penalties[start_point][end_point]))
        end

        [d, augmented]
      end

      def calculate_feature_utilities(penalities, permutation)
        utilities = Array.new permutation.size, 0

        permutation.each_with_index do |start_point, i|
          end_point = i == permutation.size - 1 ? permutation[0] : permutation[i + 1]
          start_point, end_point = end_point, start_point if end_point < start_point
          utilities[i] = distance(@space[start_point], @space[end_point]) / (1.0 + penalities[start_point][end_point])
        end

        utilities
      end

      def update_penalties!(penalties, permutation, utilities)
        max = utilities.max

        permutation.each_with_index do |start_point, i|
          end_point = i == permutation.size - 1 ? permutation[0] : permutation[i + 1]
          start_point, end_point = end_point, start_point if end_point < start_point
          penalties[start_point][end_point] += 1 if utilities[i] == max
        end

        penalties
      end

      def local_search(current, penalties)
        cost current, penalties
        count = 0

        begin
          candidate = {}
          candidate[:vector] = local_optima current[:vector]
          cost candidate, penalties
          count = candidate[:aug_cost] < current[:aug_cost] ? 0 : count + 1
          current = candidate if candidate[:aug_cost] < current[:aug_cost]
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
    GuidedLocalSearch.config do
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
      alpha 0.3
      optima 12000
    end

    best = GuidedLocalSearch.process

    puts "Done.\nBest Solution: \nc = #{best[:cost]}, \nv = #{best[:vector].inspect}"
  end

  x.report("big-random-search") do
    GuidedLocalSearch.config do
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
      alpha 0.6
      optima 2000
    end

    best = GuidedLocalSearch.process

    puts "Done.\nBest Solution: \nc = #{best[:cost]}, \nv = #{best[:vector].inspect}"
  end

  x.compare!
end
