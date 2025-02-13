require 'rails_helper'

RSpec.describe "Sources", type: :request do
  describe "GET /index" do
    it "renders a successful response" do
      get records_url
      expect(response).to be_successful
    end
  end

  describe "GET /show" do
    let(:record) { create :record, source: :os }
    it "renders a successful response" do
      get source_url(record.source)
      expect(response).to be_successful
    end
  end
end
