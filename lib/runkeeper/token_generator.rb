begin
  require 'rack'
  require 'launchy'
rescue LoadError
  puts "rack and launchy are required"
end

class Runkeeper
  class AuthorizationServer
    class App
      attr_reader :code, :env, :server

      def initialize(server)
        @server = server
      end

      def call(env)
        @env = env
        if params['code']
          @code = params['code']
          [200, { 'Content-Type' => 'text/html' }, ['Check the console for your token.']]
        else
          [404, { 'Content-Type' => 'text/html' }, ['']]
        end
      end

      def params
        @params ||= begin
          ary = env['QUERY_STRING'].split('&').map {|s| s.split('=', 2)}
          Hash[*ary.flatten]
        end
      end

    end

    def app
      @app ||= App.new(self)
    end

    def has_code?
      !code.nil?
    end

    def code
      app.code
    end

    def uri
      @uri ||= URI.parse('http://localhost:8989')
    end

    def server
      @server ||= Rack::Server.new :app => app, :Port => uri.port, :server => 'webrick'
    end

    def start
      server.start
    end

    def stop
      server.server.shutdown
    end
  end

  class Connection

    def self.authorize
      server = Runkeeper::AuthorizationServer.new
      uri = URI.parse(Configuration.authorization_url)
      uri.query = "client_id=#{Configuration.client_id}&response_type=code&redirect_uri=#{server.uri}"
      Launchy.open(uri.to_s)
      t1 = Thread.new { server.start }
      t1.join(0.5) until server.has_code?
      server.stop
      puts "Access Token: #{post_authorization(server.code, server.uri)}"
    end
  end
end
