module Sendcloud
  module V3
    class ParcelDocumentResource < Resource
      def retrieve(parcel_id:, dpi: 72, paper_size: "A6")
        get_request("parcels/#{parcel_id}/documents/label",
          params: {dpi: dpi, paper_size: paper_size},
          headers: {"Accept" => "application/pdf"})
      end
    end
  end
end
