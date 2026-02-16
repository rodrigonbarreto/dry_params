# frozen_string_literal: true

module DryParams
  module Adapters
    class Rails
      TYPE_MAPPING = {
        string: :scalar,
        integer: :scalar,
        float: :scalar,
        decimal: :scalar,
        boolean: :scalar,
        date: :scalar,
        time: :scalar,
        array: :array,
        hash: :hash,
        array_of_hashes: :array_of_hashes
      }.freeze

      def initialize(schema, options = {})
        @schema = schema
        @options = options
      end

      # Returns an array suitable for Rails permit
      # @return [Array] permit-compatible array
      def to_params
        scalars = []
        complex = {}

        @schema.fields.each do |field|
          case map_type(field.type)
          when :scalar
            scalars << field.name
          when :array
            complex[field.name] = []
          when :hash
            complex[field.name] = {}
          when :array_of_hashes
            # For array of hashes, we permit all keys inside
            complex[field.name] = {}
          end
        end

        # Rails permit format: [:name, :email, { tags: [], settings: {} }]
        complex.empty? ? scalars : scalars + [complex]
      end

      private

      def map_type(type)
        TYPE_MAPPING.fetch(type, :scalar)
      end
    end
  end
end