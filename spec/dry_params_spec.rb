# frozen_string_literal: true

require "spec_helper"
require_relative "support/test_contracts"

RSpec.describe DryParams do
  after do
    # Reset global adapter after each test
    described_class.adapter = :grape
  end

  it "has a version number" do
    expect(DryParams::VERSION).not_to be_nil
  end

  describe ".adapter" do
    it "defaults to :grape" do
      expect(described_class.adapter).to eq(:grape)
    end

    it "can be configured globally" do
      described_class.adapter = :rails
      expect(described_class.adapter).to eq(:rails)
    end
  end

  describe ".configure" do
    it "yields self for configuration" do
      described_class.configure do |config|
        config.adapter = :grape
      end

      expect(described_class.adapter).to eq(:grape)
    end
  end

  describe ".from" do
    it "returns a hash of params" do
      result = described_class.from(SimpleContract)

      expect(result).to be_a(Hash)
      expect(result.keys).to contain_exactly(:name, :age, :email)
    end

    it "marks required fields correctly" do
      result = described_class.from(SimpleContract)

      expect(result[:name][:required]).to be true
      expect(result[:age][:required]).to be true
      expect(result[:email][:required]).to be false
    end

    it "maps types correctly" do
      result = described_class.from(SimpleContract)

      expect(result[:name][:type]).to eq(String)
      expect(result[:age][:type]).to eq(Integer)
    end

    it "accepts param_type option" do
      result = described_class.from(SimpleContract, param_type: "formData")

      expect(result[:name][:documentation]).to eq({ param_type: "formData" })
    end

    it "accepts adapter override option" do
      # Uses :grape adapter even if global is different
      result = described_class.from(SimpleContract, adapter: :grape)

      expect(result).to be_a(Hash)
    end

    context "with unsupported adapter" do
      it "raises UnsupportedAdapterError" do
        expect {
          described_class.from(SimpleContract, adapter: :unknown)
        }.to raise_error(DryParams::UnsupportedAdapterError, /unknown/)
      end
    end
  end

  describe ".for (backwards compatibility)" do
    it "works as alias for .from with adapter as first arg" do
      result = described_class.for(:grape, SimpleContract)

      expect(result).to be_a(Hash)
      expect(result.keys).to contain_exactly(:name, :age, :email)
    end
  end
end
