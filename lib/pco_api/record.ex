defmodule PcoApi.Record do
  defstruct [:attributes, :id, :links, :type]

  def to_json(%PcoApi.Record{attributes: attributes, type: type}) do
    %{"data" => %{"attributes" => attributes, "type" => type}}
    |> Poison.encode!
  end
end
