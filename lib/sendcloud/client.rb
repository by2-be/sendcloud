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

    def shipping_method
      ShippingMethodResource.new(self)
    end

    def shipment
      ShipmentResource.new(self, version: :v3)
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
      when :v2 then (@connection_v2 ||= build_connection("#{BASE_DOMAIN}/api/v2")) # V2 does not allow Mock server.
      when :v3 then (@connection_v3 ||= build_connection("#{@uri}/api/v3"))
      else
        raise ArgumentError, "Unsupported version: #{version.inspect}"
      end
    end

    private

    def build_connection(base_url)
      @connection ||= Faraday.new(base_url) do |conn|
        conn.request :authorization, :AccessToken, api_key
        conn.request :json
        conn.response :json, content_type: "application/json"
        conn.response :follow_redirects, clear_authorization_header: false
        conn.adapter adapter, @stubs
      end
    end
  end
end
