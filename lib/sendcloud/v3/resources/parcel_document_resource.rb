module Sendcloud
  module V3
    class ParcelDocumentResource < Resource
      def retrieve(parcel_id:)
        response = get_request("parcels/#{parcel_id}/documents/label?dpi=72&paper_size=A6",
                               headers: { "Accept" => "application/pdf" })
        response.body
      end
    end
  end
end