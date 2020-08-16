require "json"
require "../api_helper"

module NWSClient
  class Alerts
    FETCH_PATH        = "/alerts"
    FETCH_ACTIVE_PATH = "/alerts/active"

    include JSON::Serializable
    include APIHelper

    def self.fetch_active(with client)
      fetch resource_at: FETCH_ACTIVE_PATH, with: client
    end

    class ContextArrayMember1
      include JSON::Serializable
      @[JSON::Field(key: "@version")]
      getter _version : String
      getter wx : String
      @[JSON::Field(key: "@vocab")]
      getter _vocab : String
    end

    @[JSON::Field(key: "@context")]
    getter _context : Array(String | ContextArrayMember1)
    getter type : String

    class Feature
      include JSON::Serializable
      getter id : String, type : String

      class Geometry
        include JSON::Serializable
        getter type : String, coordinates : Array(Array(Array(Float64)))
      end

      getter geometry : Geometry?

      class Properties
        include JSON::Serializable
        @[JSON::Field(key: "@id")]
        getter _id : String
        @[JSON::Field(key: "@type")]
        getter _type : String
        getter id : String
        @[JSON::Field(key: "areaDesc")]
        getter area_desc : String

        class Geocode
          include JSON::Serializable
          @[JSON::Field(key: "UGC")]
          getter ugc : Array(String)
          @[JSON::Field(key: "SAME")]
          getter same : Array(String)
        end

        getter geocode : Geocode
        @[JSON::Field(key: "affectedZones")]
        getter affected_zones : Array(String)

        class Reference
          include JSON::Serializable
          @[JSON::Field(key: "@id")]
          getter _id : String
          getter identifier : String,
            sender : String,
            sent : String
        end

        getter references : Array(Reference),
          sent : String,
          effective : String,
          onset : String?,
          expires : String,
          ends : String?,
          status : String
        @[JSON::Field(key: "messageType")]
        getter message_type : String
        getter category : String,
          severity : String,
          certainty : String,
          urgency : String,
          event : String,
          sender : String
        @[JSON::Field(key: "senderName")]
        getter sender_name : String
        getter headline : String?,
          description : String,
          instruction : String?,
          response : String

        class Parameters
          include JSON::Serializable
          @[JSON::Field(key: "eventMotionDescription")]
          getter event_motion_description : Array(String)?
          @[JSON::Field(key: "NWSheadline")]
          getter nws_headline : Array(String)?
          @[JSON::Field(key: "EAS-ORG")]
          getter eas_org : Array(String)?
          @[JSON::Field(key: "PIL")]
          getter pil : Array(String)
          @[JSON::Field(key: "BLOCKCHANNEL")]
          getter blockchannel : Array(String)
        end

        getter parameters : Parameters
      end

      getter properties : Properties
    end

    getter features : Array(Feature),
      title : String,
      updated : String

    class Pagination
      include JSON::Serializable
      getter next : String
    end

    getter pagination : Pagination?
  end
end
