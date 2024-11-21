require "rails_helper"

RSpec.describe Record, type: :model do
  describe "metadata validated on save" do
    let(:record) { create :record, metadata: { invalid: :content } }

    it "sets json_valid as false if metadata doesn't match schema" do
      expect(record.json_valid).to be_falsey
    end

    context "with valid data" do
      let(:metadata) { json_from_fixture("dataset.json") }
      let(:record) { create :record, metadata: }

      it "sets json_valid as true" do
        expect(record.json_valid).to be_truthy
      end
    end
  end
end
