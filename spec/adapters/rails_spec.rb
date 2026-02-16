# frozen_string_literal: true

require "spec_helper"
require_relative "../support/test_contracts"

RSpec.describe DryParams::Adapters::Rails do
  describe "#to_params" do
    context "with simple scalar types" do
      let(:schema) { DryParams::Schema.from_contract(SimpleContract) }
      let(:adapter) { described_class.new(schema) }

      it "returns array of field names" do
        result = adapter.to_params

        expect(result).to eq([:name, :age, :email])
      end
    end

    context "with complex types (arrays and hashes)" do
      let(:schema) { DryParams::Schema.from_contract(FullTypesContract) }
      let(:adapter) { described_class.new(schema) }

      it "returns scalars followed by complex types hash" do
        result = adapter.to_params

        # Scalars come first
        expect(result).to include(:title, :count, :price, :amount, :published_at, :starts_at, :active, :notes)

        # Complex types in a hash at the end
        complex_hash = result.last
        expect(complex_hash).to be_a(Hash)
        expect(complex_hash[:tags]).to eq([])
        expect(complex_hash[:metadata]).to eq({})
      end

      it "produces permit-compatible format" do
        result = adapter.to_params

        # Format should be: [:scalar1, :scalar2, { array: [], hash: {} }]
        scalars = result[0..-2]
        complex = result.last

        expect(scalars).to all(be_a(Symbol))
        expect(complex).to be_a(Hash)
      end
    end

    context "with only scalar types" do
      let(:schema) { DryParams::Schema.from_contract(OptionalFieldsContract) }
      let(:adapter) { described_class.new(schema) }

      it "returns only array of symbols without trailing hash" do
        result = adapter.to_params

        expect(result).to eq([:name, :nickname, :age])
        expect(result.last).to be_a(Symbol)
      end
    end
  end
end

RSpec.describe "DryParams Rails integration" do
  it "generates params via .from with adapter: :rails" do
    result = DryParams.from(SimpleContract, adapter: :rails)

    expect(result).to eq([:name, :age, :email])
  end

  it "handles complex types" do
    result = DryParams.from(FullTypesContract, adapter: :rails)

    expect(result.last).to include(tags: [], metadata: {})
  end
end