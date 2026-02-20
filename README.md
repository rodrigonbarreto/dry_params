# DryParams

> **Work in Progress** - This gem is under active development and currently used in production with Grape only.

If you use `dry-validation` extensively, you know the pain of duplicating field definitions between your contracts and your API params. This gem eliminates that repetition by automatically generating Grape params (or Rails strong params) directly from your Dry::Validation contracts.

## Installation

```ruby
gem 'dry_params'
```

## Grape

```ruby
class UserContract < Dry::Validation::Contract
  params do
    required(:name).filled(:string)
    required(:age).filled(:integer)
    optional(:email).maybe(:string)
  end
end

DryParams.from(UserContract)
# => {
#   name: { type: String, desc: "Name", required: true, documentation: { param_type: "body" } },
#   age: { type: Integer, desc: "Age", required: true, documentation: { param_type: "body" } },
#   email: { type: String, desc: "Email", required: false, documentation: { param_type: "body" } }
# }
```

Usage:

```ruby
desc "Create user", { params: DryParams.from(UserContract) }
```

For query params:

```ruby
desc "List users", { params: DryParams.from(UserFilterContract, param_type: 'query') }
```

## Rails

```ruby
DryParams.from(UserContract, adapter: :rails)
# => [:name, :age, :email]
```

With arrays and hashes:

```ruby
class PostContract < Dry::Validation::Contract
  params do
    required(:title).filled(:string)
    optional(:tags).filled(:array)
    optional(:metadata).filled(:hash)
  end
end

DryParams.from(PostContract, adapter: :rails)
# => [:title, { tags: [], metadata: {} }]
```

Usage:

```ruby
def post_params
  params.permit(DryParams.from(PostContract, adapter: :rails))
end
```

## Development

```bash
bundle exec bin/console  # interactive console
bundle exec rspec        # run tests
```

## Status

- [x] Grape adapter (production ready)
- [ ] Rails adapter (experimental)
- [ ] Nested contracts support
- [ ] Custom type mappings

## License

MIT
