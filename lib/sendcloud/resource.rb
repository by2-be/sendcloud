module Sendcloud
  class Resource
    attr_reader :client

    def initialize(client, version: :v2)
      @client = client
      @version = version
    end

    private

    def conn
      @client.connection(@version)
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
      return response if (200..202).cover?(response.status)

      error_detail = response
        .body
        .fetch("error", {})
        .fetch("message", "Unknown error")

      raise Error, error_detail
    end
  end
end
