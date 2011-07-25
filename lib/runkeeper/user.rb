class Runkeeper

  class User
    attr_reader :connection, :token

    def initialize(token)
      @token = token
      @connection = Connection.new(token)
    end

    # Profile methods
    [:name, :location, :athlete_type, :goal, :gender, :birthday, :elite, :profile, :small_picture, :normal_picture, :medium_picture, :large_picture].each do |method_name|
      define_method method_name do
        user_profile[method_name.to_s]
      end
    end
    alias elite? elite

    def id
      connection.user_response['userID']
    end

    def user_name
      profile =~ /\/user\/(.*)$/ && $1
    end

    def fitness_activities
      connection.fitness_activities
    end

    def past_activities
      connection.past_activities
    end

    def new_activity(attrs={})
      Activity.new(connection, attrs)
    end

    def activity_url(activity)
      File.join(profile, "activity", activity.id)
    end

    private

    def user_profile
      @user_profile ||= connection.profile
    end

  end

end
