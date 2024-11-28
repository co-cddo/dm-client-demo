require "rails_helper"

RSpec.describe DataMarketplaceConnector, type: :service do
  let(:token) { get_dm_token }
  let(:record) { create :record, :published }

  describe ".create" do
    let(:record) { create :record }

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

  describe ".update" do
    let(:record) do
      create :record, :published, metadata: { title: Faker::Commerce.product_name, identifier: SecureRandom.uuid }
    end
    let(:metadata) { record.metadata.except("identifier") }
    before do
      stub_request(:patch, "https://apitest.datamarketplace.gov.uk/v1/datasets/#{record.remote_id}")
        .with(
          body: metadata.to_json,
          headers: {
            "Content-Type" => "application/json",
            "Authorization" => "Bearer #{token}",
          },
        )
        .to_return(status: 200, body: "", headers: {})
    end

    it "returns success" do
      expect(described_class.update(record)).to be_success
    end
  end
end
