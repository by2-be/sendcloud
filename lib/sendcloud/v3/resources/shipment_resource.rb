module Sendcloud
  module V3
    class ShipmentResource < Resource
      def announce(payload:)
        post_request("shipments/announce", body: payload)
      end

      def cancel(shipment_id)
        post_request("shipments/#{shipment_id}/cancel", body: {})
      end

      def retrieve_shipment(shipment_id)
        get_request("shipments/#{shipment_id}")
      end
    end
  end
end