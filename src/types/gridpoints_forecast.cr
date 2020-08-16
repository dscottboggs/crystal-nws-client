require "json"
require "../errors"

module NWSClient
  class GridpointsForecast
    include JSON::Serializable
    include ErrorHelpers

    def self.fetch(grid_id, x, y, with client)
      response = client.get "/gridpoints/#{grid_id}/#{x},#{y}/forecast"
      raise api_error response unless response.success?
      from_json response.body_io? || response.body
    end

    def self.fetch(points, with client)
      fetch points.@properties.@grid_id, points.@properties.@grid_x, points.@properties.@grid_y, with: client
    end

    class ContextArrayMember1
      include JSON::Serializable
      @[JSON::Field(key: "@version")]
      getter _version : String
      getter wx : String,
        geo : String,
        unit : String
      @[JSON::Field(key: "@vocab")]
      getter _vocab : String
    end

    @[JSON::Field(key: "@context")]
    getter _context : Array(String | ContextArrayMember1)
    getter type : String

    class Geometry
      include JSON::Serializable
      getter type : String, coordinates : Array(Array(Array(Float64)))
    end

    getter geometry : Geometry

    class Properties
      include JSON::Serializable
      getter updated : String, units : String
      @[JSON::Field(key: "forecastGenerator")]
      getter forecast_generator : String
      @[JSON::Field(key: "generatedAt")]
      getter generated_at : String
      @[JSON::Field(key: "updateTime")]
      getter update_time : String
      @[JSON::Field(key: "validTimes")]
      getter valid_times : String

      class Elevation
        include JSON::Serializable
        getter value : Float64
        @[JSON::Field(key: "unitCode")]
        getter unit_code : String
      end

      getter elevation : Elevation

      class Period
        include JSON::Serializable
        getter number : Int64
        getter name : String
        @[JSON::Field(key: "startTime")]
        getter start_time : String
        @[JSON::Field(key: "endTime")]
        getter end_time : String
        @[JSON::Field(key: "isDaytime")]
        getter is_daytime : Bool
        getter temperature : Int64
        @[JSON::Field(key: "temperatureUnit")]
        getter temperature_unit : String
        @[JSON::Field(key: "temperatureTrend")]
        getter temperature_trend : String?
        @[JSON::Field(key: "windSpeed")]
        getter wind_speed : String
        @[JSON::Field(key: "windDirection")]
        getter wind_direction : String
        getter icon : String
        @[JSON::Field(key: "shortForecast")]
        getter short_forecast : String
        @[JSON::Field(key: "detailedForecast")]
        getter detailed_forecast : String
      end

      getter periods : Array(Period)
    end

    getter properties : Properties
  end
end
