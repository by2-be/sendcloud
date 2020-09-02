module Sendcloud
  class ShipmentAddress < Struct.new(:address, :number, :city, :postal_code, :country)
  end
end
