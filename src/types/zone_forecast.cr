require "json"
require "../errors"

module NWSClient
  class ZoneForecast
    include JSON::Serializable
    include ErrorHelpers

    def self.fetch(station : String, with client)
      response = client.get "/zones/forecast/#{station}/observations"
      raise api_error response unless response.success?
      from_json response.body_io? || response.body
    end

    class Context
      include JSON::Serializable
      @[JSON::Field(key: "@version")]
      getter _version : String
      getter wx : String, s : String, geo : String, unit : String
      @[JSON::Field(key: "@vocab")]
      getter _vocab : String

      class Geometry
        include JSON::Serializable
        @[JSON::Field(key: "@id")]
        getter _id : String
        @[JSON::Field(key: "@type")]
        getter _type : String
      end

      getter geometry : Geometry, city : String, state : String

      class Distance
        include JSON::Serializable
        @[JSON::Field(key: "@id")]
        getter _id : String
        @[JSON::Field(key: "@type")]
        getter _type : String
      end

      getter distance : Distance

      class Bearing
        include JSON::Serializable
        @[JSON::Field(key: "@type")]
        getter _type : String
      end

      getter bearing : Bearing

      class Value
        include JSON::Serializable
        @[JSON::Field(key: "@id")]
        getter _id : String
      end

      getter value : Value

      class UnitCode
        include JSON::Serializable
        @[JSON::Field(key: "@id")]
        getter _id : String
        @[JSON::Field(key: "@type")]
        getter _type : String
      end

      @[JSON::Field(key: "unitCode")]
      getter unit_code : UnitCode

      class ForecastOffice
        include JSON::Serializable
        @[JSON::Field(key: "@type")]
        getter _type : String
      end

      @[JSON::Field(key: "forecastOffice")]
      getter forecast_office : ForecastOffice

      class ForecastGridData
        include JSON::Serializable
        @[JSON::Field(key: "@type")]
        getter _type : String
      end

      @[JSON::Field(key: "forecastGridData")]
      getter forecast_grid_data : ForecastGridData

      class PublicZone
        include JSON::Serializable
        @[JSON::Field(key: "@type")]
        getter _type : String
      end

      @[JSON::Field(key: "publicZone")]
      getter public_zone : PublicZone

      class County
        include JSON::Serializable
        @[JSON::Field(key: "@type")]
        getter _type : String
      end

      getter county : County
    end

    @[JSON::Field(key: "@context")]
    getter _context : Array(String | Context)
    getter type : String

    class Feature
      include JSON::Serializable
      getter id : String, type : String

      class Geometry
        include JSON::Serializable
        getter type : String, coordinates : Array(Float64)
      end

      getter geometry : Geometry

      class Properties
        include JSON::Serializable
        @[JSON::Field(key: "@id")]
        getter _id : String
        @[JSON::Field(key: "@type")]
        getter _type : String

        class ValueWithUnit(T)
          include JSON::Serializable
          getter value : T?
          @[JSON::Field(key: "unitCode")]
          getter unit_code : String
          @[JSON::Field(key: "qualityControl")]
          getter quality_control : String?
        end

        getter elevation : ValueWithUnit(Float64)
        getter station : String
        getter timestamp : String
        @[JSON::Field(key: "rawMessage")]
        getter raw_message : String
        @[JSON::Field(key: "textDescription")]
        getter text_description : String
        getter icon : String?

        class PresentWeather
          include JSON::Serializable
          getter intensity : String?
          getter modifier : String?
          getter weather : String?
          @[JSON::Field(key: "rawString")]
          getter raw_string : String
        end

        @[JSON::Field(key: "presentWeather")]
        getter present_weather : Array(PresentWeather)
        getter temperature : ValueWithUnit(Float64)
        getter dewpoint : ValueWithUnit(Float64)
        @[JSON::Field(key: "windDirection")]
        getter wind_direction : ValueWithUnit(Float64)
        @[JSON::Field(key: "windSpeed")]
        getter wind_speed : ValueWithUnit(Float64)
        @[JSON::Field(key: "windGust")]
        getter wind_gust : ValueWithUnit(Float64)
        @[JSON::Field(key: "barometricPressure")]
        getter barometric_pressure : ValueWithUnit(Float64)
        @[JSON::Field(key: "seaLevelPressure")]
        getter sea_level_pressure : ValueWithUnit(Float64)
        getter visibility : ValueWithUnit(Float64)
        @[JSON::Field(key: "maxTemperatureLast24Hours")]
        getter max_temperature_last24_hours : ValueWithUnit(String)
        @[JSON::Field(key: "minTemperatureLast24Hours")]
        getter min_temperature_last24_hours : ValueWithUnit(String)
        @[JSON::Field(key: "precipitationLastHour")]
        getter precipitation_last_hour : ValueWithUnit(Float64) # This might be something else
        @[JSON::Field(key: "precipitationLast3Hours")]
        getter precipitation_last3_hours : ValueWithUnit(Float64)
        @[JSON::Field(key: "precipitationLast6Hours")]
        getter precipitation_last6_hours : ValueWithUnit(Float64)
        @[JSON::Field(key: "relativeHumidity")]
        getter relative_humidity : ValueWithUnit(Float64)
        @[JSON::Field(key: "windChill")]
        getter wind_chill : ValueWithUnit(Float64)
        @[JSON::Field(key: "heatIndex")]
        getter heat_index : ValueWithUnit(Float64)

        class CloudLayer
          include JSON::Serializable

          getter base : ValueWithUnit(Float64) # this might not be right
          getter amount : String
        end

        @[JSON::Field(key: "cloudLayers")]
        getter cloud_layers : Array(CloudLayer)
      end

      getter properties : Properties
    end

    getter features : Array(Feature)
  end
end
