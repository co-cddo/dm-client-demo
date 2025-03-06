require "rails_helper"

RSpec.describe DataMarketplaceConnector, type: :service do
  let(:token) { get_dm_token }
  let(:record) { create :record, :published }
  let(:api_url) { File.join("https://", Rails.configuration.dm_api_root_url, "v1/datasets") }

  describe ".create" do
    let(:record) { create :record }

    before do
      stub_request(:post, api_url)
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
      stub_request(:get, File.join(api_url, record.remote_id))
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

    context "with alternative root URL" do
      let(:token) { get_dm_token(root_url: "example.com") }
      let(:example_stub) do
        stub_request(:get, File.join("https://example.com/v1/datasets", record.remote_id))
          .with(
            headers: {
              "Content-Type" => "application/json",
              "Authorization" => "Bearer #{token}",
            },
          )
          .to_return(status: 200, body: "", headers: {})
      end
      before do
        example_stub
        allow(Rails.configuration).to receive(:dm_api_root_url).and_return("example.com")
      end

      it "successfully calls the new domain" do
        expect(described_class.get(record)).to be_success
        expect(example_stub).to have_been_requested
      end
    end
  end

  describe ".update" do
    let(:record) do
      create :record, :published, metadata: { title: Faker::Commerce.product_name, identifier: SecureRandom.uuid }
    end
    let(:metadata) { record.metadata.except("identifier") }
    before do
      stub_request(:patch, File.join(api_url, record.remote_id))
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

  describe ".remove" do
    before do
      stub_request(:delete, File.join(api_url, record.remote_id))
        .with(
          headers: {
            "Content-Type" => "application/json",
            "Authorization" => "Bearer #{token}",
          },
        )
        .to_return(status: 200, body: "", headers: {})
    end

    it "returns success" do
      expect(described_class.remove(record)).to be_success
    end
  end

  describe ".dataset_url" do
    it "returns the correct domain with the record remote id" do
      expect(described_class.dataset_url(record)).to eq(File.join(api_url, record.remote_id))
    end
  end
end
