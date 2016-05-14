defmodule PcoApi.People.People do
  use HTTPoison.Base
  alias PcoApi.People.Person

  @endpoint "https://api.planningcenteronline.com/people/v2/people/"

  def get do
    get("") |> Enum.map(fn(%{"attributes" => attrs, "id" => id, "links" => links}) ->
      %Person{attributes: attrs, id: id, links: links}
    end)
  end

  def get({:id, id}) do
    %{"attributes" => attrs, "id" => id, "links" => links} = get(id)
    %Person{attributes: attrs, id: id, links: links}
  end

  def get(url) do
    case get(url, [], [hackney: [basic_auth: {PcoApi.key, PcoApi.secret}]]) do
      {:ok, %HTTPoison.Response{body: body, status_code: 200}} ->
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
