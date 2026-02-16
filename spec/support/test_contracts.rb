# frozen_string_literal: true

# Test contracts for specs
class SimpleContract < Dry::Validation::Contract
  params do
    required(:name).filled(:string)
    required(:age).filled(:integer)
    optional(:email).maybe(:string)
  end
end

class FullTypesContract < Dry::Validation::Contract
  params do
    required(:title).filled(:string)
    required(:count).filled(:integer)
    required(:price).filled(:float)
    required(:amount).filled(:decimal)
    required(:published_at).filled(:date)
    required(:starts_at).filled(:time)
    required(:active).filled(:bool)
    required(:tags).filled(:array)
    required(:metadata).filled(:hash)
    optional(:notes).maybe(:string)
  end
end

class OptionalFieldsContract < Dry::Validation::Contract
  params do
    required(:name).filled(:string)
    optional(:nickname).maybe(:string)
    optional(:age).maybe(:integer)
  end
end