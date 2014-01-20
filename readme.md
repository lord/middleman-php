# middleman-php

## Installation

In your Middleman project's `Gemfile`, add:

```ruby
gem "middleman-php"
```

and in your `config.rb`, add:

```ruby
configure :development do
  activate :php
end
```

If you want the php to be parsed on builds, too (instead of left for your server to parse), just omit the `configure` block:

```ruby
activate :php
```

## FAQ

### So wait, what does this do?

It lets [Middleman](https://github.com/middleman/middleman)'s server render PHP. So your `source/kittens.php` file will actually render kittens, and not a mess of `<?php` open tags.

### Oh lord, why?? Why would you want that???

Sometimes I have clients who want little bits of PHP interactivity on their site, but I still want to use Middleman to generate the PHP pages. This makes it so you don't have to `middleman build` and then upload to your site just to get a preview.

### Are there any limitations?

It will only render on pages where the URL ends in `.php`...so if you want to see `index.php`, you'll have to actually stick `index.php` in your browser.

Also, right now the rendering is done through PHP's command line interface, which has [some limitations](http://www.php.net/manual/en/features.commandline.differences.php)...including no $_GET or $_POST. Hopefully this will be fixed in the future.

There are probably also bugs I haven't found, so if you find one, feel free to submit an issue!