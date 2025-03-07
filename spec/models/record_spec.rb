require "rails_helper"

RSpec.describe Record, type: :model do
  describe "metadata validated on save" do
    let(:record) { create :record, metadata: { invalid: :content } }

    it "sets json_valid as false if metadata doesn't match schema" do
      expect(record.json_valid).to be_falsey
    end

    it "add the validation results to validation_report" do
      expect(record.validation_report).to be_present
      expect(record.validation_report).to be_a(Array)
      expect(record.validation_report.first).to be_a(String)
    end

    context "with valid data" do
      let(:metadata) { json_from_fixture("dataset.json") }
      let(:record) { create :record, metadata: }

      it "sets json_valid as true" do
        expect(record.json_valid).to be_truthy
      end

      it "sets validation_report as empty" do
        expect(record.validation_report).to be_empty
      end
    end
  end

  describe "#published?" do
    let(:record) { create :record }
    it "returns false" do
      expect(record).not_to be_published
    end

    context "with published record" do
      let(:record) { create :record, :published }
      it "returns true" do
        expect(record).to be_published
      end
    end
  end
end
