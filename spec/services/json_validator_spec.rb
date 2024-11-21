require "rails_helper"

RSpec.describe JsonValidator, type: :service do
  describe ".valid?" do
    let(:json) { json_from_fixture("dataset.json") }

    it "is true for valid json" do
      expect(described_class.valid?(json)).to be_truthy
    end

    context "with invalid json" do
      let(:json) { { invalid: :content }.to_json }

      it "is false" do
        expect(described_class.valid?(json)).not_to be_truthy
      end
    end
  end
end
