# frozen_string_literal: true

module DryParams
  class Schema
    attr_reader :fields

    def initialize(fields)
      @fields = fields
    end

    # Factory method to create a Schema from a contract class
    def self.from_contract(contract_class)
      contract = contract_class.new
      annotations = Extractors::AnnotationExtractor.call(contract_class)

      fields = contract.schema.rules.map do |name, rule|
        Field.new(
          name: name,
          type: Extractors::TypeExtractor.call(rule),
          required: required_field?(rule),
          description: annotations[name]
        )
      end

      new(fields)
    end

    def self.required_field?(rule)
      !optional_field?(rule)
    end

    def self.optional_field?(rule)
      return true if rule.is_a?(Dry::Logic::Operations::Implication)

      if rule.is_a?(Dry::Logic::Operations::And)
        rule.rules.any? { |sub_rule| sub_rule.is_a?(Dry::Logic::Operations::Implication) }
      else
        false
      end
    end

    private_class_method :required_field?, :optional_field?
  end

  class Field
    attr_reader :name, :type, :required, :description

    def initialize(name:, type:, required:, description: nil)
      @name = name
      @type = type
      @required = required
      @description = description
    end

    def required?
      @required
    end

    def optional?
      !required?
    end
  end
end
