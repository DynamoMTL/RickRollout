# RickRollout

This gem is a thin wrapper around the [Rollout](https://github.com/fetlife/rollout) gem.
It provides a base class to enable easy conditional feature flags within environment variables.


## Installation

Add this line to your application's Gemfile:

```ruby
gem 'rick_rollout'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install rick_rollout

## Usage

The gem provides a configuration block that you can use as an initializer in Rails style:
```ruby
RickRollout.configure do |config|
      rollout = Rollout.new(Redis.new(port: 16379))
      rollout.define_group(:admins) { |user| user.admin? }
      rollout.activate_group(:my_admin_only_feature, :admins)

      config.rollout = rollout
    end
```

Please refer to the [original gem](https://github.com/fetlife/rollout) for all configuration options.

This gem depends on the `FEATURE_FLAGS_ENABLED` environment variable.

If defined and equals 1, then this gem will ask rollout if the feature is available.

If the environment variable equals 0, feature flags are disabled, meaning that the gem will always make the features available
under any conditions. **This setting is meant for development use only**.

By default `FEATURE_FLAGS_ENABLED` is enabled, you will have to have something like 
`FEATURE_FLAGS_ENABLED=0` in your environment if you wish to disable flags.

To create your first feature rollout, you need to subclass the main `RickRollout::Feature` class:

```ruby
module Feature
  class Product < RickRollout::Feature

    def all
      product = ProductRepository
      return product.all unless active?(:my_admin_only_feature, user)

      product.without_admin_products
    end
  end
end


```

![Done!](http://i.imgur.com/UNhIFnn.gif)

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/DynamoMTL/rick_rollout. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

