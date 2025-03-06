require "rails_helper"

RSpec.describe "/records", type: :request do
  let(:record) { create :record }
  let(:valid_attributes) { attributes_for :record }
  let(:invalid_attributes) do
    {
      name: "",
      metadata: "",
    }
  end
  let(:user) { create :user }

  before do
    sign_in user
  end

  describe "GET /index" do
    it "renders a successful response" do
      get records_url
      expect(response).to be_successful
    end
  end

  describe "GET /show" do
    it "renders a successful response" do
      get record_url(record)
      expect(response).to be_successful
    end

    context "with published record" do
      let(:record) { create :record, :published }
      let(:something) { Faker::Lorem.sentence }
      let(:remote_content) do
        { something: }.to_json
      end
      let(:token) { get_dm_token }

      before do
        stub_request(:get, DataMarketplaceConnector.dataset_url(record))
          .with(
            headers: {
              "Content-Type" => "application/json",
              "Authorization" => "Bearer #{token}",
            },
          )
          .to_return(status: 200, body: remote_content, headers: {})
      end

      it "displays remote content" do
        get record_url(record)
        expect(response.body).to include(something)
      end
    end
  end

  describe "GET /new" do
    it "renders a successful response" do
      get new_record_url
      expect(response).to be_successful
    end
  end

  describe "GET /edit" do
    it "renders a successful response" do
      get edit_record_url(record)
      expect(response).to be_successful
    end
  end

  describe "POST /create" do
    context "with valid parameters" do
      it "creates a new Record" do
        expect {
          post records_url, params: { record: valid_attributes }
        }.to change(Record, :count).by(1)
      end

      it "redirects to the created record" do
        post records_url, params: { record: valid_attributes }
        expect(response).to redirect_to(record_url(Record.last))
      end
    end

    context "with invalid parameters" do
      it "does not create a new Record" do
        expect {
          post records_url, params: { record: invalid_attributes }
        }.to change(Record, :count).by(0)
      end

      it "renders a response with 422 status (i.e. to display the 'new' template)" do
        post records_url, params: { record: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "PATCH /update" do
    context "with valid parameters" do
      it "updates the requested record" do
        patch record_url(record), params: { record: valid_attributes }
        record.reload
        expect(record.name).to eq(valid_attributes[:name])
      end

      it "redirects to the record" do
        patch record_url(record), params: { record: valid_attributes }
        expect(response).to redirect_to(record_url(record))
      end
    end

    context "with invalid parameters" do
      it "renders a response with 422 status (i.e. to display the 'edit' template)" do
        patch record_url(record), params: { record: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    context "with a published record" do
      let(:record) { create :record, :published }
      let(:token) { get_dm_token }
      let(:success) { double(success?: true) }

      before do
        expect(DataMarketplaceConnector).to receive(:update).with(record).and_return(success)
      end

      it "pushes the changes to the data marketplace" do
        patch record_url(record), params: { record: valid_attributes }
      end
    end
  end

  describe "DELETE /destroy" do
    it "destroys the requested record" do
      record
      expect {
        delete record_url(record)
      }.to change(Record, :count).by(-1)
    end

    it "redirects to the records list" do
      delete record_url(record)
      expect(response).to redirect_to(records_url)
    end
  end

  describe "POST /:id/publish" do
    let(:success) { true }
    let(:body) { "" }
    let(:identifier) { SecureRandom.uuid }
    let(:env) { double(response_headers: { "location" => "foo/bar/#{identifier}" }) }
    let(:dm_response) { double(success?: success, body:, env:) }
    before do
      expect(DataMarketplaceConnector).to receive(:create).with(record).and_return(dm_response)
      allow(DataMarketplaceConnector).to receive(:get).with(record).and_return(double(body: "{}"))
    end

    it "pushes the data to Data Marketplace and shows results" do
      post publish_record_url(record)
      expect(response).to redirect_to(record)
    end

    it "displays message" do
      post publish_record_url(record)
      follow_redirect!
      expect(response.body).to include("Record successfully published to Data Marketplace")
    end

    it "records the identifier as the remote id" do
      post publish_record_url(record)
      record.reload
      expect(record.remote_id).to eq(identifier)
    end

    context "with failure" do
      let(:success) { false }
      let(:message) { Faker::Lorem.sentence }
      let(:body) { { message: }.to_json }

      it "pushes the data to Data Marketplace and shows results" do
        post publish_record_url(record)
        expect(response).to redirect_to(record)
      end

      it "displays message" do
        post publish_record_url(record)
        follow_redirect!
        expect(response.body).not_to include("Record successfully published to Data Marketplace")
        expect(response.body).to include(message)
      end
    end
  end

  describe "POST /:id/unpublish" do
    let(:success) { true }
    let(:body) { "" }
    let(:dm_response) { OpenStruct.new(success?: success, body:) }
    before do
      expect(DataMarketplaceConnector).to receive(:remove).with(record).and_return(dm_response)
    end

    it "pushes the data to Data Marketplace and shows results" do
      post unpublish_record_url(record)
      expect(response).to redirect_to(record)
    end

    it "displays message" do
      post unpublish_record_url(record)
      follow_redirect!
      expect(response.body).to include("Record successfully removed from the Data Marketplace")
    end

    it "clears the remove id" do
      post unpublish_record_url(record)
      record.reload
      expect(record.remote_id).to be_blank
    end

    context "with failure" do
      let(:success) { false }
      let(:message) { Faker::Lorem.sentence }
      let(:body) { { message: }.to_json }

      it "pushes the data to Data Marketplace and shows results" do
        post unpublish_record_url(record)
        expect(response).to redirect_to(record)
      end

      it "displays message" do
        post unpublish_record_url(record)
        follow_redirect!
        expect(response.body).not_to include("Record successfully removed from the Data Marketplace")
        expect(response.body).to include(message)
      end
    end
  end
end
