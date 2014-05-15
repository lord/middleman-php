module Middleman
  class PhpMiddleware

    def initialize(app, config={})
      @app    = app
      @config = config
    end

    def call(env)
      status, headers, response = @app.call(env)

      if env['REQUEST_PATH'] =~ /\.php$/
        response.body.map! do |item|
          `echo #{Shellwords.escape(inject_params(env) + item)} | php`
        end
        headers['Content-Length'] = response.body.join.length.to_s
        headers['Content-Type']   = 'text/html'
        headers['Cache-Control']  = 'no-cache, no-store, must-revalidate'
      end

      [status, headers, response]
    end

    private

    # @TODO: Implement the default include path pointing to the script location

    # @TODO: Refactor this method to use a class for injections.
    # The new injections class should allow different type
    # of injections (parse_str, array_merge)

    def inject_params env
      injections = []

      if @config[:environment] == :development
        full_path = File.join(@config[:source_dir], env['PATH_INFO'])
        env.merge!({
          'PHP_SELF'            => env['PATH_INFO'],
          'SCRIPT_NAME'         => full_path,
          'SCRIPT_FILENAME'     => full_path,
          'DOCUMENT_ROOT'       => @config[:source_dir],
          'REQUEST_TIME'        => Time.now.to_i,
          'REQUEST_TIME_FLOAT'  => "%.4f" % Time.now.to_f,
          'SERVER_ADMIN'        => 'ruby@middlemanapp.com'
        })        
        injections << { values: URI.encode_www_form(env), array: '$_SERVER' }
      end

      unless env['QUERY_STRING'].empty?
        injections << { values: env['QUERY_STRING'], array: '$_GET' }
      end

      if env['REQUEST_METHOD'] == "POST"
        input = env["rack.input"].read
        unless input.length == 0
          injections << { values: input, array: '$_POST' }
        end
      end

      return '' unless injections.any?

      injections.collect! do |inj|
        "parse_str('#{inj[:values]}', #{inj[:array]});"
      end

      injections << "set_include_path(get_include_path() . PATH_SEPARATOR . '#{File.dirname(env['SCRIPT_FILENAME'])}');"

      "<?php #{injections.join(' ')} ?>"
    end

  end
end
