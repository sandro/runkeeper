class Runkeeper

  module Configuration
    extend self
    attr_writer :client_id, :client_secret, :authorization_url, :access_token_url

    def client_id
      @client_id || ENV['CLIENT_ID']
    end

    def client_secret
      @client_secret || ENV['CLIENT_SECRET']
    end

    def authorization_url
      @authorization_url || ENV['AUTHORIZATION_URL'] || "https://runkeeper.com/apps/authorize"
    end

    def access_token_url
      @access_token_url || ENV['ACCESS_TOKEN_URL'] || "https://runkeeper.com/apps/token"
    end
  end

end
