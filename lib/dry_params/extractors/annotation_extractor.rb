# frozen_string_literal: true

module DryParams
  module Extractors
    class AnnotationExtractor
      FIELD_PATTERN = /\s*(optional|required)\(:([\w_]+)\)/.freeze
      ANNOTATION_PATTERN = /^\s*#\s*@(\w+)\s*=\s*(.+)/.freeze

      def self.call(contract_class)
        new(contract_class).extract
      end

      def initialize(contract_class)
        @contract_class = contract_class
      end

      def extract
        source_path = find_source_file
        return {} unless source_path

        parse_annotations(File.readlines(source_path))
      end

      private

      def find_source_file
        return nil unless defined?(Rails)

        file_path = underscore(@contract_class.name)
        possible_paths.find { |path| File.exist?(path % file_path) }
                     &.then { |path| path % file_path }
      end

      def underscore(class_name)
        class_name
          .gsub("::", "/")
          .gsub(/([A-Z]+)([A-Z][a-z])/, '\1_\2')
          .gsub(/([a-z\d])([A-Z])/, '\1_\2')
          .downcase
      end

      def possible_paths
        return [] unless defined?(Rails)

        [
          Rails.root.join("app/contracts/%s.rb").to_s,
          Rails.root.join("app/api/contracts/%s.rb").to_s,
          Rails.root.join("app/models/%s.rb").to_s
        ]
      end

      def parse_annotations(lines)
        annotations = {}

        lines.each_with_index do |line, index|
          next unless line.match?(FIELD_PATTERN)

          field_name = line.match(FIELD_PATTERN)[2].to_sym
          previous_line = lines[index - 1]

          if (match = previous_line&.match(ANNOTATION_PATTERN))
            annotations[field_name] = match[2].strip if match[1] == field_name.to_s
          end
        end

        annotations
      end
    end
  end
end