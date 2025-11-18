module Sendcloud
  module V3
    class ContractResource < Resource
      def retrieve
        Contract.new get_request("contracts").body.dig("data") # TO TEST, does this pick up 2 objects?!
      end
    end
  end
end