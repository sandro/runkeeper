module Runkeeper

  class Connection
    include HTTParty
    base_uri "http://api.runkeeper.com"
    format :json
    debug_output

    ACCEPT_HEADERS = {
      :user => "application/vnd.com.runkeeper.User+json",
      :fitness_activities => "application/vnd.com.runkeeper.FitnessActivityFeed+json",
      :past_activities    => "application/vnd.com.runkeeper.FitnessActivity+json",
      :records            => "application/vnd.com.runkeeper.Records+json",
      :profile            => "application/vnd.com.runkeeper.Profile+json",
      :new_activity       => "application/vnd.com.runkeeper.NewFitnessActivity+json"
    }

    attr_reader :token, :user_response

    def initialize(token)
      @token = token
      @auth_header = {"Authorization" => "Bearer #{token}"}
      user
    end

    def user
      @user_response = self.class.get('/user', :headers => headers(:user))
    end

    def profile
      self.class.get(user_response['profile'], :headers => headers(:profile))
    end

    def fitness_activities
      self.class.get(user_response['fitness_activities'], :headers => headers(:fitness_activities))
    end

    # url: like '/fitnessActivities/66086447' or fitness_activities['items'][0]['uri']
    def past_activity(uri)
      self.class.get(uri, :headers => headers(:past_activities))
    end

    def records
      self.class.get(user_response['records'], :headers => headers(:records))
    end

    def save_activity(hash)
      self.class.post(user_response['fitness_activities'], :headers => headers(:new_activity), :body => hash.to_json)
    end

    def self.post_authorization(code, uri)
      response = post(Configuration.access_token_url, :query => {
        :grant_type => 'authorization_code',
        :code => code,
        :client_id => Configuration.client_id,
        :client_secret => Configuration.client_secret,
        :redirect_uri => uri
      })
      response['access_token']
    end

    private

    def headers(resource)
      @auth_header.merge(
        "Accept" => ACCEPT_HEADERS[resource],
        "Content-Type" => ACCEPT_HEADERS[resource]
      )
    end
  end

end
