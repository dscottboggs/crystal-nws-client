require "./spec_helper"
require "../src/types/gridpoints_forecast"

GRIDPOINT_FORECAST_SAMPLE = {{ read_file "#{__DIR__}/../samples/gridpoints_forecast.json" }}

module MockGridpointForecastClient
  extend self
  {% for method in %w(get put post delete options head) %}
    def {{method.id}}(*args, **opts)
      MockResponse
    end
  {% end %}

  module MockResponse
    extend self

    def success?
      true
    end

    def body_io
      IO::Memory.new GRIDPOINT_FORECAST_SAMPLE
    end

    def status
      HTTP::Status::OK
    end

    def body
      "error"
    end
  end
end

describe NWSClient::GridpointsForecast do
  it "parses the sample" do
    points = NWSClient::GridpointsForecast.fetch "grid id", "x", "y", with: MockGridpointForecastClient
    # arguments besides the mocked client are discarded by the client
    points.properties.periods[0].temperature.should eq 82
  end
end
