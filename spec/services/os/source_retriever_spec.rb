require "rails_helper"

RSpec.describe OS::SourceRetriever, type: :service do
  let(:item_url) { Faker::Internet.url }
  let(:namespaces) { os_xml_namespaces }
  let(:list_body) do
    <<~XML
      <dcat:CatalogRecord #{namespaces} about="#{item_url}"></dcat:CatalogRecord>
    XML
  end
  let(:item_body) { File.read(fixture_file_upload("os_source_data.xml")) }
  let(:get_first_page_of_list) do
    stub_request(:get, described_class::LIST_URL)
      .with(query: { limit: 100, startindex: 0, f: :dcat })
      .to_return(body: list_body)
  end
  let(:get_second_page_of_list) do
    stub_request(:get, described_class::LIST_URL)
      .with(query: { limit: 100, startindex: 100, f: :dcat })
      .to_return(body: "")
  end
  let(:get_individual_resource) do
    stub_request(:get, item_url)
      .with(query: { f: :dcat })
      .to_return(body: item_body)
  end
  before do
    get_first_page_of_list
    get_second_page_of_list
    get_individual_resource
  end

  describe ".call" do
    it "returns an array xml documents pulled for individual records" do
      expect(described_class.call).to eq([item_body])
    end

    it "calls to get first of page of list" do
      described_class.call
      expect(get_first_page_of_list).to have_been_requested
    end

    it "calls to get second empty page of list" do
      described_class.call
      expect(get_second_page_of_list).to have_been_requested
    end

    it "calls to get individual resource" do
      described_class.call
      expect(get_individual_resource).to have_been_requested
    end
  end
end
