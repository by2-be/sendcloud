require "test_helper"

class ShipmentResourceTest < Minitest::Test
  def test_list
    stub = stub_request(
      "shipments",
      method: :get,
      version: :v3,
      response: stub_response(fixture: "shipments/shipments", status: 200)
    )

    client = Sendcloud::Client.new(
      api_key: "key",
      api_secret: "secret",
      adapter: :test,
      stubs: stub
    )

    shipments = client.shipment.list

    assert_equal Array, shipments.class
    assert_equal "8063218c-670a-483d-ae0f-62245393e9a5", shipments.first["id"]
  end

  def test_retrieve
    shipment_id = "8063218c-670a-483d-ae0f-62245393e9a5"

    stub = stub_request(
      "shipments/#{shipment_id}",
      method: :get,
      version: :v3,
      response: stub_response(fixture: "shipments/shipments", status: 200)
    )

    client = Sendcloud::Client.new(
      api_key: "key",
      api_secret: "secret",
      adapter: :test,
      stubs: stub
    )

    shipment = client.shipment.retrieve(shipment_id: shipment_id)

    assert_equal Array, shipment.class
  end

  def test_cancel
    shipment_id = 3

    stub = stub_request(
      "shipments/#{shipment_id}/cancel",
      method: :post,
      version: :v3,
      response: stub_response(fixture: "shipments/3/cancel", status: 201)
    )

    client = Sendcloud::Client.new(
      api_key: "key",
      api_secret: "secret",
      adapter: :test,
      stubs: stub
    )

    res = client.shipment.cancel(shipment_id: shipment_id)

    assert_equal "cancelled", res["status"]
    assert_equal "Shipment has been cancelled", res["message"]
  end

  def test_announce
    stub = stub_request(
      "shipments/announce",
      method: :post,
      version: :v3,
      body: {payload: "payload"},
      response: stub_response(fixture: "shipments/announce", status: 201)
    )

    client = Sendcloud::Client.new(api_key: "key", api_secret: "secret", adapter: :test, stubs: stub)

    res = client.shipment.announce(payload: {payload: "payload"})

    label_notes = res.dig("parcels", 0, "label_notes")
    assert_equal ["I live at the blue door", "The doorbell isn\u2019t working"], label_notes
  end
end
