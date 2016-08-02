defmodule PcoApi.People.Household do
  use PcoApi.Actions

  import PcoApi.RecordAssociation
  linked_association :household_memberships
  linked_association :people

  def list(params) when is_list(params), do: get(params, "households")

  def get(id) when is_integer(id), do: get("households/#{id}")

  def self(%PcoApi.Record{id: id}), do: get("households/#{id}")

  def new(attrs) when is_list(attrs), do: new(attrs, "Household")

  def create(%PcoApi.Record{type: "Household"} = record), do: create(record, "households")
end
