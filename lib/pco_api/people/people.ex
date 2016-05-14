defmodule PcoApi.People.People do
  use HTTPoison.Base
  alias PcoApi.People.Person

  @endpoint "https://api.planningcenteronline.com/people/v2/people/"

  def get do
    get("", [])
  end

  # params = {attr, value} ie {"first_name", "geoffrey"}
  def get({:where, params}) do
    params = params |> Enum.map(fn ({attr, value}) -> {"where[#{attr}]", value} end)
    get("", params)
  end

  def get({:id, id}, []) do
    get(id)
  end

  def get(url, options) do
    # options = Keyword.merge(options, [hackney: [basic_auth: {PcoApi.key, PcoApi.secret}]])
    case get(url, [], params: options, hackney: [basic_auth: {PcoApi.key, PcoApi.secret}]) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        body["data"]
      {:ok, %HTTPoison.Response{body: body}} ->
        %{"errors" => [%{"detail" => detail, "title" => title}]} = body
        raise "Request returned non-200 response. Error: #{title}: #{detail}"
      {:error, _} ->
        raise "PcoApi.People error"
    end
  end

  def process_url(url) do
    @endpoint <> url
  end

  def process_response_body(body) do
    body
    |> Poison.decode!
  end
end
