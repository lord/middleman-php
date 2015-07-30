require 'shellwords'

module Middleman
  class PhpExtension < Extension

    option :show_debug, false, 'Output debug info to console.'

    def initialize(app, options_hash={}, &block)
      super
    end

    def before
      template_extensions :php => :html
    end

    def after_configuration
      app.use Middleman::PhpMiddleware, options_for_middleware
    end

    private

    def options_for_middleware
      options.to_h.merge(
        source_dir: app.source_dir,
        environment: app.settings.environment
      )
    end

  end
end
