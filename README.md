# middleman-php

**middleman-php** allows [Middleman][mm_repo] to execute PHP scripts. So your `source/kittens.php` file will actually render kittens, and not a mess of `<?php` open tags.

Sometimes I have clients who want little bits of PHP interactivity on their site, but I still want to use Middleman to generate the PHP pages. This makes it so you don't have to `middleman build` and then upload to your site just to get a preview.

[![Gem Version](https://badge.fury.io/rb/middleman-php.svg)][gem]

## Installation

Add the extension to your `Gemfile`:

```ruby
gem 'middleman-php'
```

And then run:

```
bundle install
```

## Configuration

You can activate the extension by adding the following to your `config.rb` file:

```ruby
configure :development do
  activate :php
end
```

If you want the PHP to be parsed on builds too (as opposed to raw PHP generated for a server to run), just omit the `configure` block:

```ruby
activate :php
```

Here is the list of settings with the default values:

```ruby
activate :php do |config|
  config.show_debug = false # Output debug info to console
end
```

## How does it work?

The PHP code will be executed only on pages where the URL ends in `.php` so if you want to see `index.php`, you'll have to actually stick `index.php` in your browser.

It will however, let you do fancy stuff like files ending in `.php.erb`... so your ERB can generate some PHP output.

## Bug Reports

There are probably also bugs I haven't found, so if you find one, feel free to submit an issue!

## License

Copyright (c) 2014-2015 Robert Lord. MIT Licensed, see [LICENSE] for details.

[mm_repo]: https://github.com/middleman/middleman
[gem]: https://rubygems.org/gems/middleman-php
[LICENSE]: https://github.com/lord/middleman-php/blob/master/LICENSE.md
