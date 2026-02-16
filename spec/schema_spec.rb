# frozen_string_literal: true

require "spec_helper"
require_relative "support/test_contracts"

RSpec.describe DryParams::Schema do
  describe ".from_contract" do
    it "creates a schema with fields from contract" do
      schema = described_class.from_contract(SimpleContract)

      expect(schema.fields.size).to eq(3)
      expect(schema.fields.map(&:name)).to contain_exactly(:name, :age, :email)
    end

    it "identifies required fields" do
      schema = described_class.from_contract(SimpleContract)

      name_field = schema.fields.find { |f| f.name == :name }
      email_field = schema.fields.find { |f| f.name == :email }

      expect(name_field).to be_required
      expect(email_field).to be_optional
    end

    it "extracts field types" do
      schema = described_class.from_contract(SimpleContract)

      name_field = schema.fields.find { |f| f.name == :name }
      age_field = schema.fields.find { |f| f.name == :age }

      expect(name_field.type).to eq(:string)
      expect(age_field.type).to eq(:integer)
    end
  end
end

RSpec.describe DryParams::Field do
  describe "#required?" do
    it "returns true for required fields" do
      field = described_class.new(name: :test, type: :string, required: true)
      expect(field).to be_required
    end

    it "returns false for optional fields" do
      field = described_class.new(name: :test, type: :string, required: false)
      expect(field).not_to be_required
    end
  end

  describe "#optional?" do
    it "returns the inverse of required" do
      required_field = described_class.new(name: :test, type: :string, required: true)
      optional_field = described_class.new(name: :test, type: :string, required: false)

      expect(required_field).not_to be_optional
      expect(optional_field).to be_optional
    end
  end
end
