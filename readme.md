# middleman-php

**middleman-php** lets [Middleman](https://github.com/middleman/middleman)'s server render PHP. So your `source/kittens.php` file will actually render kittens, and not a mess of `<?php` open tags.

Sometimes I have clients who want little bits of PHP interactivity on their site, but I still want to use Middleman to generate the PHP pages. This makes it so you don't have to `middleman build` and then upload to your site just to get a preview.

## Installation

In your Middleman project's `Gemfile`, add:

```ruby
gem 'middleman-php'
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
  config.show_debug = true # Output debug info to console
end
```

## How does it work?

The PHP code will be executed only on pages where the URL ends in `.php` so if you want to see `index.php`, you'll have to actually stick `index.php` in your browser.

It will however, let you do fancy stuff like files ending in `.php.erb`... so your ERB can generate some PHP output.

## Bug Reports

There are probably also bugs I haven't found, so if you find one, feel free to submit an issue!

## Credits

Also thanks to [Mariano](https://github.com/mcavallo), who contributed a significant chunk of code to get $_GET, $_POST, and other PHP global request variables working.

Copyright (c) 2014-2015 Robert Lord.
