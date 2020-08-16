require "http"

module NWSClient
  class Exception < ::Exception
  end

  class APIError < Exception
    property status : HTTP::Status, body : String?

    def initialize(@status, @body, type)
      super %[Failed to request #{type} from server: "#{status}"\nResponse body:\n\n#{@body}]
    end
  end

  module ErrorHelpers
    macro included
      def self.api_error(response)
        APIError.new response.status, response.body, self
      end
    end
  end
end
