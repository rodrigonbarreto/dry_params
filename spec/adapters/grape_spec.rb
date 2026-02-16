# frozen_string_literal: true

require "spec_helper"
require_relative "../support/test_contracts"

RSpec.describe DryParams::Adapters::Grape do
  describe "#to_params" do
    let(:schema) { DryParams::Schema.from_contract(FullTypesContract) }
    let(:adapter) { described_class.new(schema) }

    it "returns a hash with all fields" do
      result = adapter.to_params

      expect(result.keys).to contain_exactly(
        :title, :count, :price, :amount, :published_at,
        :starts_at, :active, :tags, :metadata, :notes
      )
    end

    it "maps string to String" do
      result = adapter.to_params
      expect(result[:title][:type]).to eq(String)
    end

    it "maps integer to Integer" do
      result = adapter.to_params
      expect(result[:count][:type]).to eq(Integer)
    end

    it "maps float to Float" do
      result = adapter.to_params
      expect(result[:price][:type]).to eq(Float)
    end

    it "maps decimal to Float" do
      result = adapter.to_params
      expect(result[:amount][:type]).to eq(Float)
    end

    it "maps date to Date" do
      result = adapter.to_params
      expect(result[:published_at][:type]).to eq(Date)
    end

    it "maps time to Time" do
      result = adapter.to_params
      expect(result[:starts_at][:type]).to eq(Time)
    end

    it "maps boolean to Grape::API::Boolean string" do
      result = adapter.to_params
      expect(result[:active][:type]).to eq("Grape::API::Boolean")
    end

    it "maps array to Array" do
      result = adapter.to_params
      expect(result[:tags][:type]).to eq(Array)
    end

    it "maps hash to Hash" do
      result = adapter.to_params
      expect(result[:metadata][:type]).to eq(Hash)
    end

    it "includes description from field name when no annotation" do
      result = adapter.to_params
      expect(result[:title][:desc]).to eq("Title")
    end

    it "includes required flag" do
      result = adapter.to_params
      expect(result[:title][:required]).to be true
      expect(result[:notes][:required]).to be false
    end

    it "includes documentation with default param_type" do
      result = adapter.to_params
      expect(result[:title][:documentation]).to eq({ param_type: "body" })
    end

    context "with custom param_type" do
      let(:adapter) { described_class.new(schema, param_type: "formData") }

      it "uses custom param_type in documentation" do
        result = adapter.to_params
        expect(result[:title][:documentation]).to eq({ param_type: "formData" })
      end
    end
  end
end