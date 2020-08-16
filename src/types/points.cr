require "json"
require "../api_helper"

module NWSClient
  class Points
    include APIHelper
    include JSON::Serializable

    def self.fetch(latitude : Float64, longitude : Float64, with client)
      fetch resource_at: "/points/#{latitude},#{longitude}", with: client
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
    getter _context : Array(String | Context), id : String, type : String

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
      getter cwa : String
      @[JSON::Field(key: "forecastOffice")]
      getter forecast_office : String
      @[JSON::Field(key: "gridId")]
      getter grid_id : String
      @[JSON::Field(key: "gridX")]
      getter grid_x : Int64
      @[JSON::Field(key: "gridY")]
      getter grid_y : Int64
      getter forecast : String
      @[JSON::Field(key: "forecastHourly")]
      getter forecast_hourly : String
      @[JSON::Field(key: "forecastGridData")]
      getter forecast_grid_data : String
      @[JSON::Field(key: "observationStations")]
      getter observation_stations : String

      class RelativeLocation
        include JSON::Serializable
        getter type : String

        class Geometry
          include JSON::Serializable
          getter type : String, coordinates : Array(Float64)
        end

        getter geometry : Geometry

        class Properties
          include JSON::Serializable
          getter city : String, state : String

          class Distance
            include JSON::Serializable
            getter value : Float64
            @[JSON::Field(key: "unitCode")]
            getter unit_code : String
          end

          getter distance : Distance

          class Bearing
            include JSON::Serializable
            getter value : Int64
            @[JSON::Field(key: "unitCode")]
            getter unit_code : String
          end

          getter bearing : Bearing
        end

        getter properties : Properties
      end

      @[JSON::Field(key: "relativeLocation")]
      getter relative_location : RelativeLocation
      @[JSON::Field(key: "forecastZone")]
      getter forecast_zone : String
      getter county : String
      @[JSON::Field(key: "fireWeatherZone")]
      getter fire_weather_zone : String
      @[JSON::Field(key: "timeZone")]
      getter time_zone : String
      @[JSON::Field(key: "radarStation")]
      getter radar_station : String
    end

    getter properties : Properties
  end
end
