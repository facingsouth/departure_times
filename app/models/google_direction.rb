class GoogleDirection

  OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE

  include HTTParty

  base_uri 'https://maps.googleapis.com'

  def initialize(origin      = "312 northwood dr, south san francisco, ca 94080", 
                 destination = "505 Parnassus Ave., San Francisco, CA 94143")
    @data = {}
    @origin = origin
    @destination = destination
    @travel_mode = "transit"
  end

  def data_parser
    response = get_response
    return @data = { :status => "service not available" } unless response
    return @data = { :status => response["status"] } unless response["status"] == "OK"
    # @data = { :distance => distance(response),
    #           :duration => duration(response),
    #           :price    => price(response),
    #           :mode     => travel_mode,
    #           :availability => 5.0
    # }
    @data = { :agency         => agency(response),
              :departure_time => departure_time(response),
              :departure_stop => departure_stop(response)
    }
  end

  # private

  def get_response
    parameters = { query: {
      'key' => ENV['GOOGLE_DIRECTION_API_KEY'],
      'origin' => "#{origin}",
      'destination' => "#{destination}",
      'mode'=> travel_mode
      }
    }
    self.class.get('/maps/api/directions/json', parameters)
  end

  def agency(response)
    find_transit(response)
    @transit_details["line"]["agencies"][0]["name"]
  end

  def departure_time(response)
    find_transit(response)
    @transit_details["departure_time"]["text"]
  end

  def departure_stop(response)
    find_transit(response)
    @transit_details["departure_stop"]["name"]
  end

  def find_transit(response)
    unless @transit_details
      steps = response["routes"][0]["legs"][0]["steps"]
      steps.each do |step|
        if step["travel_mode"] == "TRANSIT"
          @transit_details = step["transit_details"]
          puts "find it"
          break
        end
      end
    end
  end

  def origin
    @origin
  end

  def destination
    @destination
  end

  def travel_mode
    @travel_mode
  end

end