# MallocTrim

There is currently a proposal for the ruby language to call malloc_trim(0) on GC runs to more efficiently give memory back to the operating system. This is a gem giving access to malloc_trim to ruby land to ease testing.

```ruby
require 'malloc_trim'
MallocTrim.trim # most effective when doing a GC.start before
```

For an explanation on why this works, read:

* https://www.joyfulbikeshedding.com/blog/2019-03-14-what-causes-ruby-memory-bloat.html

And find the official proposal for introducing this into ruby here:

* https://bugs.ruby-lang.org/issues/15667

Since `malloc_trim` is not available on MacOS systems, this won't have any effect there. Call `MallocTrim.trimming_possible?` to check whether `malloc_trim` is available.

For testing purposes, this gem also provides `MallocTrim.enable_trimming` (and it's counterpart `disable_trimming`) which calls `malloc_trim` after every GC run.

I, personally, found it most effective when running

```
GC.start
MallocTrim.trim
```

after a heavy job. This frees memory where repeated calls to only `GC.start` does not free any memory.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'malloc_trim'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install malloc_trim

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment. Note that MacOS systems don't ship with `malloc_trim` so this gem will have nothing to do on these systems.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/tessi/malloc_trim. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the MallocTrim project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/tessi/malloc_trim/blob/master/CODE_OF_CONDUCT.md).
