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
    let(:dm_response) { OpenStruct.new(success?: success, body:) }
    before do
      expect(DataMarketplaceConnector).to receive(:create).with(record).and_return(dm_response)
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
end
