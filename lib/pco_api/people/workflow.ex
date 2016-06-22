defmodule PcoApi.People.Workflow do
  import PcoApi.RecordAssociation
  linked_association :cards
  linked_association :steps

  use PcoApi.Actions

  def list(params) when is_list(params), do: get(params, "workflows")

  def get(id) when is_integer(id), do: get("workflows/#{id}")

  def self(%PcoApi.Record{id: id}), do: get(String.to_integer(id))
end
