module Sendcloud
  class Client
    BASE_DOMAIN = "https://panel.sendcloud.sc"

    attr_reader :api_key, :api_secret, :uri, :adapter

    def initialize(api_key:, api_secret:, uri: BASE_DOMAIN, adapter: Faraday.default_adapter, stubs: nil)
      @api_key = api_key
      @api_secret = api_secret
      @uri = uri
      @adapter = adapter

      # Test stubs for requests
      @stubs = stubs
    end

    def parcel
      ParcelResource.new(self)
    end

    def parcel_status
      ParcelStatusResource.new(self)
    end

    def label
      LabelResource.new(self)
    end

    def service_point
      service_point_client = ServicePointClient.new(api_key: api_key, adapter: adapter, stubs: @stubs)
      service_point_client.service_point
    end

    def connection(version = :v2)
      case version.to_sym
      when :v2 then (@connection_v2 ||= build_connection("#{BASE_DOMAIN}/api/v2"))
      when :v3
        base_uri =
          if @uri == BASE_DOMAIN
            "#{BASE_DOMAIN}/api/v3"
          else
            @uri
          end

        @connection_v3 ||= build_connection(base_uri)
      else
        raise ArgumentError, "Unsupported version: #{version.inspect}"
      end
    end

    private

    def build_connection(base_url)
      @connection ||= Faraday.new(base_url) do |conn|
        conn.request :authorization, :basic, api_key, api_secret
        conn.request :json
        conn.response :json, content_type: "application/json"
        conn.adapter adapter, @stubs
      end
    end
  end
end
