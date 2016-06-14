require 'middleman-core'

::Middleman::Extensions.register(:php) do
  require 'middleman-php/middleware'
  require 'middleman-php/extension'
  ::Middleman::Php::Extension
end
