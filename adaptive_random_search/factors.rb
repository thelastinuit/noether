module AdaptiveRandomSearch
  class Factors
    def initialize(config)
      @config = config
    end

    def initial
      @config[:initial_factor]
    end

    def small
      @config[:small_factor]
    end

    def large
      @config[:large_factor]
    end
  end
end
