# frozen_string_literal: true

require "spec_helper"
require_relative "../support/test_contracts"

RSpec.describe DryParams::Extractors::TypeExtractor do
  describe ".call" do
    let(:contract) { FullTypesContract.new }
    let(:rules) { contract.schema.rules }

    it "extracts string type" do
      expect(described_class.call(rules[:title])).to eq(:string)
    end

    it "extracts integer type" do
      expect(described_class.call(rules[:count])).to eq(:integer)
    end

    it "extracts float type" do
      expect(described_class.call(rules[:price])).to eq(:float)
    end

    it "extracts decimal type" do
      expect(described_class.call(rules[:amount])).to eq(:decimal)
    end

    it "extracts date type" do
      expect(described_class.call(rules[:published_at])).to eq(:date)
    end

    it "extracts time type" do
      expect(described_class.call(rules[:starts_at])).to eq(:time)
    end

    it "extracts boolean type" do
      expect(described_class.call(rules[:active])).to eq(:boolean)
    end

    it "extracts array type" do
      expect(described_class.call(rules[:tags])).to eq(:array)
    end

    it "extracts hash type" do
      expect(described_class.call(rules[:metadata])).to eq(:hash)
    end

    it "defaults to string for unknown types" do
      # notes is maybe(:string) which should still be string
      expect(described_class.call(rules[:notes])).to eq(:string)
    end
  end
end