require 'test_helper'

class ShipmentResourceTest < Minitest::Test
  def test_list
    stub = stub_request(
      'shipments',
      method: :get,
      version: :v3,
      response: stub_response(fixture: 'shipments/shipments', status: 200)
    )

    client = Sendcloud::Client.new(
      api_key: 'key',
      api_secret: 'secret',
      adapter: :test,
      stubs: stub
    )

    shipments = client.shipment.list

    assert_equal Array, shipments.class
    assert_equal '8063218c-670a-483d-ae0f-62245393e9a5', shipments.first['id']
  end

  def test_retrieve
    shipment_id = '8063218c-670a-483d-ae0f-62245393e9a5'

    stub = stub_request(
      "shipments/#{shipment_id}",
      method: :get,
      version: :v3,
      response: stub_response(fixture: 'shipments/shipments', status: 200)
    )

    client = Sendcloud::Client.new(
      api_key: 'key',
      api_secret: 'secret',
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
      response: stub_response(fixture: 'shipments/3/cancel', status: 201)
    )

    client = Sendcloud::Client.new(
      api_key: 'key',
      api_secret: 'secret',
      adapter: :test,
      stubs: stub
    )

    res = client.shipment.cancel(shipment_id: shipment_id)

    assert_equal 'cancelled', res['status']
    assert_equal 'Shipment has been cancelled', res['message']
  end

  def test_announce
    payload = {
      label_details: {
        mime_type: 'application/pdf',
        dpi: 72
      },
      to_address: {
        name: 'John Doe',
        company_name: 'Sendcloud',
        address_line_1: 'Insulindelaan 115',
        house_number: '115',
        postal_code: '5642CV',
        city: 'Eindhoven',
        country_code: 'NL',
        phone_number: '+31612345678',
        email: 'john.doe@sendcloud.com',
        po_box: 'PO Box 678'
      },
      from_address: {
        name: 'Marie Doe',
        company_name: 'Sendcloud',
        address_line_1: 'Stadhuisplein 10',
        address_line_2: '2e verdieping',
        house_number: '10',
        postal_code: '5611 EM',
        city: 'Eindhoven',
        country_code: 'NL',
        phone_number: '+31612345678',
        email: 'marie.doe@sendcloud.com',
        po_box: 'PO Box 478'
      },
      ship_with: {
        type: 'shipping_option_code',
        properties: {
          shipping_option_code: 'postnl:standard',
          contract_id: 517
        }
      },
      order_number: '1234567890',
      total_order_price: {
        currency: 'EUR',
        value: '11.11'
      },
      parcels: [
        {
          dimensions: {
            length: '5.00',
            width: '15.00',
            height: '20.00',
            unit: 'cm'
          },
          weight: {
            value: '1.320',
            unit: 'kg'
          },
          label_notes: [
            'I live at the blue door',
            "The doorbell isn't working"
          ],
          parcel_items: [
            {
              item_id: '5552',
              description: 'T-Shirt XL',
              quantity: 1,
              weight: {
                value: 0.3,
                unit: 'kg'
              },
              price: {
                value: 12.65,
                currency: 'EUR'
              },
              hs_code: '620520',
              origin_country: 'NL',
              sku: 'TS1234',
              product_id: '19284',
              mid_code: 'NLOZR92MEL',
              material_content: '100% Cotton',
              intended_use: 'Personal use',
              properties: {
                size: 'XL',
                color: 'green'
              }
            },
            {
              item_id: '98712',
              description: 'Sneakers 42',
              quantity: 1,
              weight: {
                value: 1.02,
                unit: 'kg'
              },
              price: {
                value: 12.65,
                currency: 'EUR'
              },
              hs_code: '620520',
              origin_country: 'US',
              sku: 'TS1234',
              product_id: '19284',
              mid_code: 'US1234567',
              material_content: '100% Cotton',
              intended_use: 'Personal use',
              properties: {
                size: 42,
                color: 'black'
              }
            }
          ]
        }
      ]
    }

    stub = stub_request(
      'shipments/announce',
      method: :post,
      version: :v3,
      body: payload,
      response: stub_response(fixture: 'shipments/announce', status: 201)
    )

    client = Sendcloud::Client.new(api_key: 'key', api_secret: 'secret', adapter: :test, stubs: stub)

    res = client.shipment.announce(payload: payload)

    label_notes = res.dig('parcels', 0, 'label_notes')
    assert_equal ['I live at the blue door', "The doorbell isn\u2019t working"], label_notes
  end
end
