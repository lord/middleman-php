module Middleman
  class PhpMiddleware

    def initialize(app)
      @app = app
    end

    def call(env)
      status, headers, response = @app.call(env)

      if env['REQUEST_PATH'] =~ /\.php$/
        response.body.map! do |item|
          `echo #{Shellwords.escape(inject_params(env) + item)} | php`
        end
        headers['Content-Length'] = response.body.join.length.to_s
        headers['Content-Type'] = 'text/html'
      end

      [status, headers, response]
    end

    private

    def inject_params env
      injections = []
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
      "<?php #{injections.join(' ')} ?>"
    end

  end
end
