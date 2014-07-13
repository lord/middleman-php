require 'middleman-php/injections.rb'

module Middleman
  class PhpMiddleware

    def initialize(app, config={})
      @injections = Middleman::Php::Injections.new(true)
      @app        = app
      @config     = config
      @env        = []
    end

    def call(env)
      status, headers, response = @app.call(env)

      if env['REQUEST_PATH'] =~ /\.php$/
        set_environment(env)
        response.body.map! do |item|
          execute_php(item)
        end
        headers['Content-Length'] = ::Rack::Utils.bytesize(response.body.join).to_s
        headers['Content-Type']   = 'text/html'
        headers['Cache-Control']  = 'no-cache, no-store, must-revalidate'
      end

      [status, headers, response]
    end

    private

    def set_environment env
      @env = env
    end

    def execute_php source
      inject_server
      inject_script_directory
      inject_include_path
      inject_get
      inject_post
      `echo #{Shellwords.escape(@injections.generate + source)} | php`
    end

    def inject_server
      if @config[:environment] == :development
        @injections.add_server(@config[:source_dir], @env)
      end
    end

    def inject_script_directory
      if @config[:environment] == :development
        @injections.set_current_directory(@config[:source_dir], @env['REQUEST_PATH'])
      end
    end

    def inject_include_path
      if @config[:environment] == :development
        @injections.add_include_path(@config[:source_dir], @env['PATH_INFO'])
      end
    end

    def inject_get
      unless @env['QUERY_STRING'].empty?
        @injections.add_get(@env['QUERY_STRING'])
      end
    end

    def inject_post
      if @env['REQUEST_METHOD'] == "POST"
        @injections.add_post(@env["rack.input"])
      end
    end

  end
end
