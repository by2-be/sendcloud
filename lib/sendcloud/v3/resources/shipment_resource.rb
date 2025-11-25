module Sendcloud
  module V3
    class ShipmentResource < Resource

      def announce(payload:)
        response = post_request("shipments/announce", body: payload)
        response.body
      end

      def cancel(shipment_id:)
        response = post_request("shipments/#{shipment_id}/cancel", body: {})
        response.body
      end

      def shipments
        response = get_request("shipments")
        Collection.from_response(response, key: "data", type: ShipmentResource)
      end
    end
  end
end