# DryParams

**Single source of truth for your API params.**

DryParams generates Grape API parameters and Swagger documentation directly from your `Dry::Validation` contracts. Define your validations once, use them everywhere.

## The Problem

Without DryParams, you duplicate your validation logic:

```ruby
# 1. Contract (validation)
class UserCreateContract < Dry::Validation::Contract
  params do
    required(:name).filled(:string)
    required(:email).filled(:string)
    required(:age).filled(:integer)
  end
end

# 2. Grape API (duplicated!)
params do
  requires :name, type: String
  requires :email, type: String
  requires :age, type: Integer
end
```

## The Solution

With DryParams, your contract IS your documentation:

```ruby
class UserCreateContract < Dry::Validation::Contract
  params do
    # @name = User's full name
    required(:name).filled(:string)
    # @email = Valid email address
    required(:email).filled(:string)
    # @age = Must be 18 or older
    required(:age).filled(:integer)
  end
end

# Grape API - just reference the contract!
desc "Create user", {
  params: DryParams.from(UserCreateContract)
}
```

## Installation

Add to your Gemfile:

```ruby
gem 'dry_params'
```

Then:

```bash
bundle install
```

## Usage

### Basic Usage

```ruby
DryParams.from(UserCreateContract)
# => {
#   name: { type: String, required: true, desc: "User's full name", documentation: { param_type: "body" } },
#   email: { type: String, required: true, desc: "Valid email address", documentation: { param_type: "body" } },
#   age: { type: Integer, required: true, desc: "Must be 18 or older", documentation: { param_type: "body" } }
# }
```

### With Grape API

```ruby
module V2
  class Users < Grape::API
    resource :users do
      desc "Create a user", {
        params: DryParams.from(UserCreateContract)
      }
      post do
        contract = UserCreateContract.new
        result = contract.call(params)
        error!({ errors: result.errors.to_h }, 422) if result.failure?
        # ... create user
      end
    end
  end
end
```

### Custom param_type

```ruby
DryParams.from(UserCreateContract, param_type: 'formData')
```

### Annotations

Add descriptions to your contract fields using comments:

```ruby
class LessonCreateContract < Dry::Validation::Contract
  params do
    # @title = Title of the lesson
    required(:title).filled(:string)
    # @date_lesson = Date when the lesson occurs
    required(:date_lesson).filled(:date)
    # @max_students = Maximum number of students allowed
    required(:max_students).filled(:integer)
  end
end
```

The comments become the `desc` field in the generated params.

## Supported Types

| Dry::Validation | Grape Type |
|-----------------|------------|
| `:string` | `String` |
| `:integer` | `Integer` |
| `:float` | `Float` |
| `:decimal` | `Float` |
| `:bool` | `Grape::API::Boolean` |
| `:date` | `Date` |
| `:time` | `Time` |
| `:array` | `Array` |
| `:hash` | `Hash` |

## Configuration

```ruby
# config/initializers/dry_params.rb
DryParams.configure do |config|
  config.adapter = :grape  # default
end
```

## Development

```bash
bin/setup
bundle exec rspec
```

## License

MIT