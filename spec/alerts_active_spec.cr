require "./spec_helper"
require "../src/types/alerts"

ALERTS_ACTIVE_SAMPLE = {{ read_file "#{__DIR__}/../samples/alerts_active.json" }}

module MockActiveAlertsClient
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
      IO::Memory.new ALERTS_ACTIVE_SAMPLE
    end

    def status
      HTTP::Status::OK
    end

    def body
      "error"
    end
  end
end

describe NWSClient::Alerts do
  it "parses the sample" do
    points = NWSClient::Alerts.fetch_active with: MockActiveAlertsClient
    points.features[0].properties.event.should eq "Flood Warning"
  end
end
