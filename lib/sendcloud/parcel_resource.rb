module Sendcloud
  class ParcelResourceException < StandardError; end

  class ParcelResource < Base
    def create_parcel(name, shipment_address, shipment = { id: 1, options: [] }, method_params = {})
      response = self.class.post("/parcels",
                                 body: {
                                   parcel: {
                                     name: name,
                                     address: shipment_address.address,
                                     house_number: shipment_address.number,
                                     city: shipment_address.city,
                                     postal_code: shipment_address.postal_code,
                                     country: shipment_address.country,
                                     shipment: shipment,
                                     requestShipment: false,
                                   }.merge(method_params),
                                 }.to_json,
                                 basic_auth: auth,
                                 headers: { "Content-Type" => "application/json" })
      handle_response_error(response)
      response["parcel"]
    end

    def create_parcels(name, shipment_address, shipment = { id: 1, options: [] }, qty = 1, method_params = {})
      parcel = {
        name: name,
        address: shipment_address.address,
        house_number: shipment_address.number,
        city: shipment_address.city,
        postal_code: shipment_address.postal_code,
        country: shipment_address.country,
        shipment: shipment,
        requestShipment: false,
      }.merge(method_params)

      parcels = []
      external_reference = parcel[:external_reference]
      qty.times do |i|
        cloned_parcel = parcel.clone
        cloned_parcel[:external_reference] = external_reference + "-#{i}" if external_reference
        parcels << cloned_parcel
      end

      response = self.class.post("/parcels",
                                 body: {
                                   parcels: parcels,
                                 }.to_json,
                                 basic_auth: auth,
                                 headers: { "Content-Type" => "application/json" })
      handle_response_error(response)
      response["parcels"]
    end

    def adjust_parcel(parcel_id)
      response = self.class.put("/parcels",
                                body: {
                                  parcel: {
                                    id: parcel_id,
                                    requestShipment: true,
                                  },
                                }.to_json,
                                basic_auth: auth,
                                headers: { "Content-Type" => "application/json" })
      handle_response_error(response)
      response["parcel"]
    end

    def show_parcel(parcel_id)
      response = self.class.get("/parcels/#{parcel_id}", basic_auth: auth)
      handle_response_error(response)
      response["parcel"]
    end

    def get_label_parcel(parcel_id)
      response = self.class.get("/labels/#{parcel_id}", basic_auth: auth,
                                                        headers: { "Content-Type" => "application/json" })
      handle_response_error(response)
      response["label"]
    end

    def cancel_parcel(parcel_id)
      response = self.class.post("/parcels/#{parcel_id}/cancel", basic_auth: auth,
                                                                 header: { "Content-Type" => "application/json" })
      handle_response_error(response)
      response
    end

    private

    def handle_response_error(response)
      if response["error"]
        raise ParcelResourceException.new(response["error"]["message"])
      end
    end
  end
end
