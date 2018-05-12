require_relative "core"

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
  end
end
