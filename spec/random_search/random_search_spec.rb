require "spec_helper"

describe RandomSearch do
  before do
    RandomSearch.config do
      space Array.new(8) { |_i| [-5, +5] }
      iteration 100
      benchmarking? true
    end
  end

  describe "#process" do
    it {
      allow(RandomSearch).to receive(:process).and_return(vector: Array.new, cost: 1.0)
      expect(RandomSearch.process).to eq(vector: Array.new, cost: 1.0)
    }
  end

  describe "#space" do
    it {
      expect(RandomSearch.configuration[:space]).to be_kind_of Array
    }
  end

  describe "#iteration" do
    it {
      expect(RandomSearch.configuration[:iteration]).to eq(100)
    }
  end

  describe "#benchmarking?" do
    it {
      expect(RandomSearch.configuration[:benchmarking]).to be true
    }
  end
end
