defmodule PcoApi.People.Tab do
  @moduledoc false

  import PcoApi.RecordAssociation
  linked_association(:field_definitions)

  use PcoApi.Actions

  def list(params) when is_list(params), do: get(params, "tabs")

  def get(id) when is_integer(id), do: get("tabs/#{id}")

  def self(%PcoApi.Record{id: id}), do: get(String.to_integer(id))

  def new(attrs) when is_list(attrs), do: new(attrs, "Tab")

  def create(%PcoApi.Record{type: "Tab"} = record), do: create(record, "tabs")
end
