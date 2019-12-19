defmodule PcoApi.Record do
  @moduledoc false

  defstruct [:attributes, :id, :links, :type]

  def to_json(%PcoApi.Record{attributes: attributes, type: type}) do
    %{"data" => %{"attributes" => attributes, "type" => type}}
    |> Poison.encode!()
  end

  def to_record(results) when is_list(results) do
    results |> Enum.map(&(&1 |> to_record))
  end

  def to_record(%{"id" => id, "links" => links, "attributes" => attrs, "type" => type}) do
    %PcoApi.Record{id: id, links: links, attributes: attrs, type: type}
  end
end
