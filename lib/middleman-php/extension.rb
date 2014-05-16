require 'shellwords'

module Middleman
  class PhpExtension < Extension

    def initialize(app, options_hash={}, &block)
      super
    end

    def before
      template_extensions :php => :html
    end

    def after_configuration      
      app.use Middleman::PhpMiddleware,
        source_dir: app.source_dir,
        environment: app.settings.environment
    end

  end
end
