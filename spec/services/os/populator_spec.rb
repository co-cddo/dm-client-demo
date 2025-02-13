require "rails_helper"

RSpec.describe OS::Populator, type: :service do
  let(:xml) { File.read(fixture_file_upload("os_source_data.xml")) }
  let(:metadata) { OS::RecordProcessor.metadata_from(source_data: xml) }

  describe "#populate" do
    subject(:populate) { described_class.new(xml).populate }

    it "creates a new record" do
      expect { populate }.to change(Record, :count).by(1)
    end

    it "returns the record" do
      expect(populate).to be_a(Record)
    end

    it "stores the source xml" do
      expect(populate.source_data).to eq(xml)
    end

    it "stores the metadata created from the xml (with type modified)" do
      metadata["type"] = "Data Set"
      expect(populate.metadata).to eq(metadata)
    end

    it "uses the supplier identifier as the unique name" do
      expect(populate.name).to eq(metadata["supplierIdentifier"])
    end
  end
end
