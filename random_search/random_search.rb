require_relative "core"

module RandomSearch
  class << self
    attr_reader :configuration

    def config(&block)
      @configuration = {}

      class_eval &block
    end

    def process
      RandomSearch::Core.new(@configuration).best
    end

    def space(value)
      @configuration[:space] = value
    end

    def iteration(value)
      @configuration[:iteration] = value
    end

    def benchmarking?(value)
      @configuration[:benchmarking] = value
    end
  end
end
