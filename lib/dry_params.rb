# frozen_string_literal: true

require "date"

require_relative "dry_params/version"
require_relative "dry_params/schema"
require_relative "dry_params/extractors/type_extractor"
require_relative "dry_params/extractors/annotation_extractor"
require_relative "dry_params/adapters/grape"
require_relative "dry_params/adapters/rails"

module DryParams
  class Error < StandardError; end
  class UnsupportedAdapterError < Error; end

  ADAPTERS = {
    grape: Adapters::Grape,
    rails: Adapters::Rails
  }.freeze

  class << self
    # Global adapter configuration (default: :grape)
    attr_writer :adapter

    def adapter
      @adapter ||= :grape
    end

    # Configure DryParams
    #
    # @example
    #   DryParams.configure do |config|
    #     config.adapter = :grape
    #   end
    #
    def configure
      yield self
    end

    # Main entry point - converts a Dry::Validation::Contract to framework params
    #
    # @param contract_class [Class] the Dry::Validation::Contract class
    # @param options [Hash] additional options
    # @option options [Symbol] :adapter Override the global adapter (:grape, :rails)
    # @option options [String] :param_type Swagger param type (default: 'body')
    # @return [Hash] params hash for the target framework
    #
    # @example Basic usage
    #   DryParams.from(UserCreateContract)
    #
    # @example With options
    #   DryParams.from(UserCreateContract, param_type: 'formData')
    #
    # @example Override adapter
    #   DryParams.from(UserCreateContract, adapter: :rails)
    #
    def from(contract_class, options = {})
      selected_adapter = options.delete(:adapter) || adapter
      adapter_class = ADAPTERS[selected_adapter]

      raise UnsupportedAdapterError, "Adapter '#{selected_adapter}' not supported" unless adapter_class

      schema = Schema.from_contract(contract_class)
      adapter_class.new(schema, options).to_params
    end

    # Legacy API - kept for backwards compatibility
    # @deprecated Use {.from} instead
    def for(adapter_name, contract_class, options = {})
      from(contract_class, options.merge(adapter: adapter_name))
    end
  end
end