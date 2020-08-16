require "./errors"

module NWSClient
  module APIHelper
    macro included
      include ErrorHelpers

      # Fetch the resource with the client, yielding to the block if the request was not successful
      def self.fetch(with client, *, resource_at path = FETCH_PATH)
        response = client.get path
        yield response unless response.success?
        from_json response.body_io? || response.body
      end

      # Fetch the resource with the client, raising an NWSClient::APIError if the request was not successful
      def self.fetch(with client, *, resource_at path = FETCH_PATH)
        fetch(resource_at: path, with: client) { |response| raise api_error response }
      end
    end
  end
end
