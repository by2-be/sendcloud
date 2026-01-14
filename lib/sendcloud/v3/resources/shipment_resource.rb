module Sendcloud
  module V3
    class ShipmentResource < Resource
      def list(**params)
        get_request('shipments', params: params)
      end

      def retrieve(shipment_id:)
        get_request("shipments/#{shipment_id}")
      end

      def announce(payload:)
        post_request('shipments/announce', body: payload)
      end

      def cancel(shipment_id:)
        post_request("shipments/#{shipment_id}/cancel", body: {})
      end
    end
  end
end
