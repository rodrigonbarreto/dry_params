# frozen_string_literal: true

module DryParams
  module Adapters
    class Grape
      TYPE_MAPPING = {
        string: String,
        integer: Integer,
        float: Float,
        decimal: Float,
        boolean: "Grape::API::Boolean",
        date: Date,
        time: Time,
        array: Array,
        hash: Hash,
        array_of_hashes: [Hash]
      }.freeze

      DEFAULT_TYPE = String

      def initialize(schema, options = {})
        @schema = schema
        @param_type = options[:param_type] || "body"
      end

      def to_params
        @schema.fields.each_with_object({}) do |field, params|
          params[field.name] = build_param(field)
        end
      end

      private

      def build_param(field)
        {
          type: map_type(field.type),
          desc: field.description || field.name.to_s.tr("_", " ").capitalize,
          required: field.required?,
          documentation: { param_type: @param_type }
        }
      end

      def map_type(type)
        TYPE_MAPPING.fetch(type, DEFAULT_TYPE)
      end
    end
  end
end