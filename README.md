# Rack::UtmCookies

A rack middleware that searches for [UTM tags](https://support.google.com/analytics/answer/1033867?hl=en) in the request params, and stores them in cookies for later use.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'rack-utm_cookies'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install rack-utm_cookies


## Usage

*Use with Rails 4*

Add `Rack::Utm` as a rack middleware:

    # config/application.rb
    class Application < Rails::Application
      #...
      # if you want cookies set for the current request passed into your rails app,
      # you'll need to include this middleware before "ActionDispatch::Cookies"
      config.middleware.insert_before "ActionDispatch::Cookies", Rack::UtmCookies
      #...
    end

## Development

After checking out the repo, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Credit

Thanks to [silvermind/rack-utm](https://github.com/silvermind/rack-utm) - rack-utm_cookies is largely a tidy up of that project.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/rack-utm_cookies.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

