require 'shellwords'

module Middleman
  class PhpExtension < Extension

    option :debug, false, 'Print debug to console.'

    def initialize(app, options_hash={}, &block)
      super
    end

    def before
      template_extensions :php => :html
    end

    def after_configuration
      app.use Middleman::PhpMiddleware, options.to_h.merge(
        source_dir: app.source_dir,
        environment: app.settings.environment
      )
    end

  end
end
