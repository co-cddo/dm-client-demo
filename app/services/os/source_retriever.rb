class OS::SourceRetriever
  LIST_URL = "https://osmetadata.astuntechnology.com/geonetwork/api/collections/main/items".freeze

  def self.call
    new.objects
  end

  def objects
    @objects ||= get_array_of_objects
  end

private

  def get_array_of_objects
    urls = list_of_object_urls
    urls.collect do |url|
      url.gsub! "{", "%7B"
      url.gsub! "}", "%7D"
      response = Faraday.get("#{url}?f=dcat")
      response.body
    end
  end

  def list_of_object_urls
    limit = 100
    startindex = 0
    urls = []
    while (hundred = get_urls(limit, startindex).presence)
      urls << hundred
      startindex += limit
    end
    urls.flatten!
    urls
  end

  def get_urls(limit, startindex)
    url = URI(LIST_URL)
    url.query = {
      limit:,
      startindex:,
      f: :dcat,
    }.to_query
    response = Faraday.get(url)
    doc = Nokogiri::XML(response.body)
    doc.remove_namespaces!
    doc.xpath("//CatalogRecord[@about]").collect(&:values)
  end
end
