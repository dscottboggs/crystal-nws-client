require "./spec_helper"
require "../src/types/points"

POINTS_SAMPLE = {{ read_file "#{__DIR__}/../samples/points.json" }}

module MockPointsClient
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
      IO::Memory.new POINTS_SAMPLE
    end

    def status
      HTTP::Status::OK
    end

    def body
      "error"
    end
  end
end

describe NWSClient::Points do
  it "parses the sample" do
    points = NWSClient::Points.fetch 12.3, 45.6, with: MockPointsClient
    # Actual latitude and longitude values are discarded since we're mocking the client
    points.properties.grid_id.should eq "PBZ"
  end
end
