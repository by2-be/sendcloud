require "test_helper"

class ParcelDocumentResourceTest < Minitest::Test
  def test_retrieve
    parcel_id = "1"
    captured_env = nil

    stub = Faraday::Adapter::Test::Stubs.new do |stub|
      stub.get(%r{\A/parcels/#{parcel_id}/documents/label}) do |env|
        captured_env = env

        [200, {"Content-Type" => "application/pdf"}, "PDF"]
      end
    end

    client = Sendcloud::Client.new(api_key: "key", api_secret: "secret", adapter: :test, stubs: stub)

    resource = Sendcloud::V3::ParcelDocumentResource.new(client, version: :v3)
    resource.retrieve(parcel_id: parcel_id)

    assert_equal "/parcels/#{parcel_id}/documents/label", captured_env.url.path

    query = captured_env.url.query
    assert_includes query, "dpi=72"
    assert_includes query, "paper_size=A6"

    assert_equal "application/pdf", captured_env.request_headers['Accept']

    auth = captured_env.request_headers['Authorization']
    assert_match(/^Basic/, auth)

    encoded = auth.split(" ", 2).last
    decoded = Base64.decode64(encoded)
    assert_equal "key:secret", decoded
  end
end