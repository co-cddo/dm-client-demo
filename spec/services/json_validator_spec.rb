require "rails_helper"

RSpec.describe JsonValidator, type: :service do
  let(:json) { json_from_fixture("dataset.json") }
  let(:invalid) do
    { invalid: :content }.to_json
  end

  describe ".valid?" do
    it "is true for valid json" do
      expect(described_class.valid?(json)).to be_truthy
    end

    context "with invalid json" do
      let(:json) { invalid }

      it "is false" do
        expect(described_class.valid?(json)).not_to be_truthy
      end
    end
  end

  describe "#report" do
    subject(:report) { json_validator.report }
    let(:json_validator) { described_class.new(json) }

    it "returns empty array if JSON valid" do
      expect(report).to be_empty
    end

    context "with invalid json" do
      let(:json) { invalid }

      it "returns an array of strings describing the problems" do
        expect(report).to be_present
        expect(report).to be_a(Array)
        expect(report.first).to be_a(String)
      end
    end
  end
end
