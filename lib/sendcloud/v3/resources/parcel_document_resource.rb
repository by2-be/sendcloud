module Sendcloud
  module V3
    class ParcelDocumentResource < Resource
      def retrieve(parcel_id)
        get_request("parcels/#{parcel_id}/documents/label?dpi=72&paper_size=A6",
                               headers: { "Accept" => "application/pdf" })
      end
    end
  end
end