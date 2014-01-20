module Middleman
  class PhpExtension < Extension
    # option :set_blah, "default", "An example option"

    def initialize(app, options_hash={}, &block)
      # Call super to build options from the options_hash
      super

      require 'shellwords'
      app.use Middleman::PhpMiddleware

      app.before do
        template_extensions :php => :html
      end
    end
  end
end
