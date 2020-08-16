# TODO: Write documentation for `Nws::Client`
module NWSClient
  VERSION    = "0.1.0"
  USER_AGENT = "Crystal.dscottboggs.NWSClient/#{VERSION}"
  CLIENT     = HTTP::Client.new URI.new host: "api.weather.gov", scheme: "https"

  CLIENT.before_request do |request|
    request.headers["User-Agent"] = USER_AGENT
    request.headers["Accept"] = "application/json"
  end
end
