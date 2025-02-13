require "rails_helper"

RSpec.describe OS::RecordProcessor, type: :service do
  describe "getting data from source" do
    let(:source_data) do
      <<~XML
        <dcat:CatalogRecord #{namespaces}>
        </dcat:CatalogRecord>
      XML
    end
    let(:namespaces) { os_xml_namespaces }
    subject(:record_processor) { described_class.new(source_data:) }

    it "populates metadata" do
      expect(record_processor.metadata).to be_present
    end

    it "adds supplemetary info" do
      expect(record_processor.metadata["accessRights"]).to eq(described_class::SUPPLEMENTARY["accessRights"])
    end

    context "with an identifier" do
      let(:identifier) { SecureRandom.uuid }
      let(:source_data) do
        <<~XML
          <dcat:CatalogRecord #{namespaces}>
            <dct:identifier>#{identifier}</dct:identifier>
          </dcat:CatalogRecord>
        XML
      end
      it "stores the identified in supplier identifier" do
        expect(record_processor.metadata["supplierIdentifier"]).to eq(identifier)
      end
    end

    context "with a blank identifier" do
      let(:identifier) { SecureRandom.uuid }
      let(:source_data) do
        <<~XML
          <dcat:CatalogRecord #{namespaces}>
            <dct:identifier></dct:identifier>
          </dcat:CatalogRecord>
        XML
      end
      it "stores an empty supplier identifier" do
        expect(record_processor.metadata["supplierIdentifier"]).to be_empty
      end
    end

    context "with a nested element" do
      let(:email) { Faker::Internet.email }
      let(:source_data) do
        <<~XML
          <dcat:Dataset #{namespaces}>
            <dcat:contactPoint>
              <vcard:hasEmail>#{email}</vcard:hasEmail>
            </dcat:contactPoint>
          </dcat:Dataset>
        XML
      end
      it "maintains the nesting" do
        expect(record_processor.metadata.dig("contactPoint", 0, "email")).to eq(email)
      end
    end

    context "with data in tag attribute" do
      let(:url) { Faker::Internet.url }
      let(:source_data) do
        <<~XML
          <dcat:Distribution #{namespaces}>
            <dcat:accessURL rdf:resource="#{url}"></dcat:accessURL>
          </dcat:Distribution>
        XML
      end
      it "is able to retrive the data and store it in the correct place" do
        expect(record_processor.metadata.dig("distribution", 0, "downloadURL")).to eq(url)
      end
    end
  end
end
