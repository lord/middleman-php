require "middleman-core"
require "middleman-php/version"

::Middleman::Extensions.register(:php) do
  require 'middleman-php/middleware'
  require 'middleman-php/extension'
  ::Middleman::PhpExtension
end