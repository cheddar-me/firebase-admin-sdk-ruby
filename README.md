# Firebase Admin Ruby SDK

The Firebase Admin Ruby SDK enables access to Firebase services from privileged environments (such as servers or cloud)
in Ruby.

For more information, visit the
[Firebase Admin SDK setup guide](https://firebase.google.com/docs/admin/setup/).

This gem is currently in alpha and not recommended for production use (yet).

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'firebase-admin-sdk'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install firebase-admin-sdk

## Usage

### Application Default Credentials

```ruby
gem 'firebase-admin-sdk'

app = Firebase::Admin::App.new
```

### Using a service account

```ruby
gem 'firebase-admin-sdk'

creds = Firebase::Admin::Credentials.from_file('service_account.json')
app = Firebase::Admin::App.new(credentials: creds)
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/cheddar-me/firebase-admin-sdk.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
