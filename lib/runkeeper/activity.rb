class Runkeeper

  class Activity
    attr_reader :connection, :url
    attr_reader :type, :start_time, :total_distance, :duration, :average_heart_rate, :total_calories, :notes, :path, :post_to_facebook, :post_to_twitter

    def initialize(connection, attrs)
      @connection = connection
      @attrs = attrs
      attrs.each do |k,v|
        instance_variable_set("@#{k}", v)
      end
    end

    def save
      @save_response = connection.save_activity(to_hash)
    end

    def id
      @save_response && @save_response.headers['location'][/\d+$/]
    end

    def formatted_start_time
      start_time.strftime("%a, %d %b %Y %H:%M:%S")
    end

    def to_hash
      main = {
        :type => type,
        :start_time => formatted_start_time,
        :duration => duration
      }
      main.merge! optional_attrs
    end

    def optional_attrs
      h = {}
      [
        :total_distance,
        :average_heart_rate,
        :total_calories,
        :notes,
        :path,
        :post_to_facebook,
        :post_to_twitter
      ].each do |method_name|
        v = send(method_name)
        h[method_name] = v if v
      end
      h
    end

  end
end
