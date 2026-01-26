module Sendcloud
  module V3
    class Resource
      attr_reader :client

      def initialize(client)
        @client = client
      end

      private

      def conn
        @client.connection(:v3)
      end

      def get_request(url, params: {}, headers: {})
        handle_response conn.get(url, params, headers)
      end

      def post_request(url, body:, headers: {})
        handle_response conn.post(url, body, headers)
      end

      def patch_request(url, body:, headers: {})
        handle_response conn.patch(url, body, headers)
      end

      def put_request(url, body:, headers: {})
        handle_response conn.put(url, body, headers)
      end

      def delete_request(url, params: {}, headers: {})
        handle_response conn.delete(url, params, headers)
      end

      def handle_response(response)
        body = response.body

        case response.status
        when 200..202
          return body if response.headers["content-type"] == "application/pdf"
          body.fetch("data")
        when 409
          error_detail = "Conflict error #{response.status}: #{body.inspect}"
          raise ConflictError.new(error_detail, response:)
        else
          error_detail = if body.key?("errors")
            body
              .fetch("errors")
              .map { |error| error["detail"] }
              .join(", ")
          else
            "Unknown error #{response.status}: #{body.inspect}"
          end

          raise Error.new(error_detail, response:)
        end
      end
    end
  end
end
