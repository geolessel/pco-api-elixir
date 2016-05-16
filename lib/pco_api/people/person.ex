defmodule PcoApi.People.Person do
  use PcoApi.ActionsTwo
  defstruct [:attributes, :id, :links, :type]

  endpoint "https://api.planningcenteronline.com/people/v2/people/"
  linked_association "field_data"

  def households(%PcoApi.Record{links: %{"households" => url}}) do
    url |> associated_records
  end

  def associated_records(url) do
    request(:get, url, [])
    |> Enum.map(fn(%{"attributes" => attrs, "id" => id, "links" => links, "type" => type}) ->
      %PcoApi.Record{attributes: attrs, id: id, links: links, type: type}
    end)
  end

  def addresses(%PcoApi.Record{links: %{"addresses" => url}}) do
    request(:get, url, [])
    |> Enum.map(fn(%{"attributes" => attrs, "id" => id, "links" => links}) ->
      %PcoApi.People.Address{attributes: attrs, id: id, links: links}
    end)
  end

  def get, do: get("")
  def get(url), do: request(:get, url, []) |> new

  def new(results) when is_list(results), do: results |> Enum.map(&(&1 |> new))
  def new(%{"id" => id, "links" => links, "attributes" => attrs, "type" => type}) do
    %PcoApi.Record{id: id, links: links, attributes: attrs, type: type}
  end
end
