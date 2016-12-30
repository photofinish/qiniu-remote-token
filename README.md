# QiniuRemoteTocken

Welcome to your new gem! In this directory, you'll find the files you need to be able to package up your Ruby library into a gem. Put your Ruby code in the file `lib/qiniu_remote_tocken`. To experiment with that code, run `bin/console` for an interactive prompt.

TODO: Delete this and the text above, and describe your gem

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'qiniu-remote-token', :git => 'git@github.com:photofinish/qiniu-remote-token.git'
```

And then execute:

    $ bundle

## Usage

### Server

controller

```
require 'qiniu-remote-token/server'
class AuthsController < ActionController::Base
  include QiniuRemoteToken::Server
  def show
    if 'a-client' == params[:id]
      json = Struct.new :ak, :bucket
      render json: json.new(Service.access_key, Service.bucket)
    end
  end

  def create
    params.require :scope
    params.require :deadline
    @uploadToken = Service.generate_token params
    render json:  { token: @uploadToken }
  end
end
```

config

```
development:
  qiniu_access_key: xxx
  qiniu_secret_key: xxx
  qiniu_bucket_domain: xxx
  qiniu_bucket: xxx
```

### Client

uploader

```
require 'qiniu-remote-token/client'
class ImageUploader < CarrierWave::Uploader::Base
  include QiniuRemoteToken::Client
end
```

config

```
qiniu_access_key: http://localhost:3000/auths/a-client
qiniu_secret_key: http://localhost:3000/auths
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/qiniu_remote_tocken. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

