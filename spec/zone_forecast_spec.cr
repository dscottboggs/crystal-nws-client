require "./spec_helper"
require "../src/types/zone_forecast"

ZONE_FORECAST_SAMPLE = {{ read_file "#{__DIR__}/../samples/zone_forecast.json" }}

module MockZoneForecastClient
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
      IO::Memory.new ZONE_FORECAST_SAMPLE
    end

    def status
      HTTP::Status::OK
    end

    def body
      "error"
    end
  end
end

describe NWSClient::ZoneForecast do
  it "parses the sample" do
    points = NWSClient::ZoneForecast.fetch "station", with: MockZoneForecastClient
    # Station value is discarded since mocked client pays no attention to its args
    points.features[1].properties.temperature.value.should eq 22.5
  end
end
