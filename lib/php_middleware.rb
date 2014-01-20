class PhpMiddleware

  def initialize(app)
    @app = app
  end

  def call(env)
    status, headers, response = @app.call(env)

    if env['REQUEST_PATH'] =~ /\.php$/
      response.body.map! do |item|
        `echo #{Shellwords.escape(item)} | php`
      end
      headers['Content-Length'] = response.body.join.length.to_s
      headers['Content-Type'] = 'text/html'
    end

    [status, headers, response]
  end

end
