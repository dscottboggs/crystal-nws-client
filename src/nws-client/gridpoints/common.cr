require "../../nws-client"
require "../../types/gridpoints_forecast.cr"

module NWSClient
  def self.gridpoints(wfo, x, y)
    Gridpoints.new wfo, x, y
  end

  record Gridpoints, wfo : String, x : Int32, y : Int32 do
    {% for method in %w(raw hourly_forecast stations) %}
      def {{method.id}}
        raise "{{method.id}} not yet implemented"
      end
    {% end %}
  end
end
