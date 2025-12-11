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
        if (200..202).include?(response.status)
          return response.body if response.headers["content-type"] == "application/pdf"
          return response.body.fetch("data")
        end

        error_detail = response
         .body
         .fetch("errors")
         .map { |error| error["detail"] }
         .join(", ")

        raise Error, error_detail
      end
    end
  end
end
