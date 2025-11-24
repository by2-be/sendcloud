module Sendcloud
  module V3
    class ShipmentResource < Resource

      def announce(payload:)
        response = Shipment.new post_request("shipments/announce", body: payload).body

        debugger

        Collection.from_response(response, key: "data", type: Shipment)
      end

      def cancel(shipment_id:)
        post_request("shipments/#{shipment_id}/cancel", body: {}).body
      end

      def shipments
        response = get_request("shipments")
        Collection.from_response(response, key: "data", type: Shipment)
      end
    end
  end
end