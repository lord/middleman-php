module Middleman
  module Php
    class Injections

      def initialize(debug=false)
        @debug      = debug
        @injections = []
      end

      def add_server(source_dir, env)
        full_path = File.join(source_dir, env['PATH_INFO'])
        env.merge!({
          'PHP_SELF'            => env['PATH_INFO'],
          'SCRIPT_NAME'         => full_path,
          'SCRIPT_FILENAME'     => full_path,
          'DOCUMENT_ROOT'       => source_dir,
          'REQUEST_TIME'        => Time.now.to_i,
          'REQUEST_TIME_FLOAT'  => "%.4f" % Time.now.to_f,
          'SERVER_ADMIN'        => 'ruby@middlemanapp.com'
        })
        add_parse_str(URI.encode_www_form(env), '$_SERVER')
      end

      def add_post(rack_input)
        input = rack_input.read
        unless input.length == 0
          add_parse_str(input.gsub("'", "\\\\'"), '$_POST')
        end
      end

      def add_get(query_string)
        add_parse_str(query_string, '$_GET')
      end

      def add_request
        # Using default value "EGPCS" for php.ini directive variable_order.
        add_raw('$_REQUEST = array_merge($_ENV, $_GET, $_POST, $_COOKIE, $_SERVER);')
      end

      def set_current_directory(source_dir, script_path)
        dir_path = File.dirname(File.join(source_dir, script_path))
        add_raw("chdir(#{dir_path.inspect});")
      end

      def add_include_path(source_dir, path_info)
        path = File.dirname(File.join(source_dir, path_info))
        add_raw("set_include_path(get_include_path() . PATH_SEPARATOR . '#{path}');")
      end

      def add_default_session
        add_raw("session_id('middleman-php-session');")
      end

      def generate
        if @injections.any?
          injections = "<?php #{@injections.join(' ')} ?>"
          if @debug
            puts '== PHP Injections:'
            puts injections
          end
        end
        return injections || ''
      end

      private

      def add_parse_str(values, array_name)
        @injections << "parse_str('#{values}', #{array_name});"
      end

      def add_raw(source)
        @injections << source
      end

    end
  end
end
