require "spec_helper"

describe RandomSearch::Space do
  subject {
    RandomSearch::Space.new [1,1]
  }

  describe "#size" do
    it {
      expect(subject.size).to eq(2)
    }
  end

  describe "#row" do
    it {
      expect(subject.row(0)).to eq(subject)
    }

    it {
      expect(subject.column(0).row(0)).to eq(1)
    }
  end

  describe "#column" do
    it {
      expect(subject.column(0)).to eq(subject)
    }

    it {
      expect(subject.row(0).column(0)).to eq(1)
    }
  end
end
