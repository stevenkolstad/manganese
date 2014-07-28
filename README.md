# Manganese

Mongoid multi tenant using multiple database

[![Build Status](https://travis-ci.org/marcosanson/manganese.svg?branch=master)](https://travis-ci.org/marcosanson/manganese)
[![Test Coverage](https://codeclimate.com/github/marcosanson/manganese/coverage.png)](https://codeclimate.com/github/marcosanson/manganese)
[![Code Climate](https://codeclimate.com/github/marcosanson/manganese.png)](https://codeclimate.com/github/marcosanson/manganese)
[![Inline docs](http://inch-ci.org/github/marcosanson/manganese.png)](http://inch-ci.org/github/marcosanson/manganese)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'manganese', github: 'marcosanson/manganese'
```

## Usage

TODO: Working progress...

## Testing

Manganese provides the following two testing modes:

- A test `fake` mode that always use only one database

- A `live` mode that create a database for each tenant

### Setup RSpec 3.x

```ruby
require 'manganese/testing'

RSpec.configure do |config|
  config.before(:each) do |example|
    if example.metadata[:manganese] == :fake
      Manganese::Testing.fake!
    elsif example.metadata[:manganese] == :live
      Manganese::Testing.live!
    elsif example.metadata[:type] == :acceptance
      Manganese::Testing.live!
    else
      Manganese::Testing.fake!
    end
  end

  config.after(:each) do
    Manganese.reset_tenant!
  end
end
```

## Contributing

1. Fork it ( https://github.com/[my-github-username]/manganese/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
