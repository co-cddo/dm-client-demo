def get_dm_token(root_url: Rails.configuration.dm_api_root_url)
  token = SecureRandom.uuid
  stub_request(:post, File.join("https://", root_url, "/v1/clientauth/get-token"))
    .with(
      body: Rails.configuration.dm_api.to_json,
      headers: { "Content-Type" => "application/json" },
    )
    .to_return(status: 200, body: { token: }.to_json)
  token
end
