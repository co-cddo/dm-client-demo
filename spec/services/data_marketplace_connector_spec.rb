require "rails_helper"

RSpec.describe DataMarketplaceConnector, type: :service do
  let(:token) { SecureRandom.uuid }
  let(:record) { create :record }
  before do
    stub_request(:post, "https://apitest.datamarketplace.gov.uk/v1/clientauth/get-token")
      .with(
        body: Rails.configuration.dm_api.to_json,
        headers: { "Content-Type" => "application/json" },
      )
      .to_return(status: 200, body: { token: }.to_json)
  end

  describe ".create" do
    before do
      stub_request(:post, "https://apitest.datamarketplace.gov.uk/v1/datasets")
        .with(
          body: record.metadata.to_json,
          headers: {
            "Content-Type" => "application/json",
            "Authorization" => "Bearer #{token}",
          },
        )
        .to_return(status: 200, body: "", headers: {})
    end

    it "returns success" do
      expect(described_class.create(record)).to be_success
    end
  end

  describe ".get" do
    let(:record) { create :record, :published }

    before do
      stub_request(:get, "https://apitest.datamarketplace.gov.uk/v1/datasets/#{record.remote_id}")
        .with(
          headers: {
            "Content-Type" => "application/json",
            "Authorization" => "Bearer #{token}",
          },
        )
        .to_return(status: 200, body: "", headers: {})
    end

    it "returns success" do
      expect(described_class.get(record)).to be_success
    end
  end
end
