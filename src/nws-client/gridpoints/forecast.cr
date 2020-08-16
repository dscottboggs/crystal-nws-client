require "./common"

struct NWSClient::Gridpoints
  def forecast
    GridpointsForecast.fetch wfo, x, y, with: CLIENT
  end
end
