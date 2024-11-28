def get_dm_token
  token = SecureRandom.uuid
  stub_request(:post, "https://apitest.datamarketplace.gov.uk/v1/clientauth/get-token")
    .with(
      body: Rails.configuration.dm_api.to_json,
      headers: { "Content-Type" => "application/json" },
    )
    .to_return(status: 200, body: { token: }.to_json)
  token
end
