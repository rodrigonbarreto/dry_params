# frozen_string_literal: true

module DryParams
  module Extractors
    class TypeExtractor
      PREDICATES = {
        /int\?/ => :integer,
        /date\?/ => :date,
        /time\?/ => :time,
        /float\?/ => :float,
        /decimal\?/ => :decimal,
        /bool\?/ => :boolean,
        /array\? AND each\(hash\?/ => :array_of_hashes,
        /array\?/ => :array,
        /hash\?/ => :hash
      }.freeze

      DEFAULT_TYPE = :string

      def self.call(rule)
        new(rule).extract
      end

      def initialize(rule)
        @rule_string = rule.to_s
      end

      def extract
        PREDICATES.each do |pattern, type|
          return type if @rule_string.match?(pattern)
        end

        DEFAULT_TYPE
      end
    end
  end
end