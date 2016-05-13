defmodule PcoApi.People do
  use HTTPoison.Base

  @endpoint "https://api.planningcenteronline.com/people/v2/"

  def get(url) do
    get(url, [], [hackney: [basic_auth: {PcoApi.key, PcoApi.secret}]])
  end

  def process_url(url) do
    @endpoint <> url
  end
end
