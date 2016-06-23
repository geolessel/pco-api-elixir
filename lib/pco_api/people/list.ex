defmodule PcoApi.People.List do
  import PcoApi.RecordAssociation
  linked_association :created_by
  linked_association :owner
  linked_association :people
  linked_association :rules
  linked_association :shares
  linked_association :updated_by

  use PcoApi.Actions

  def list(params) when is_list(params), do: get(params, "lists")

  def get(id) when is_integer(id), do: get("lists/#{id}")

  def run(%PcoApi.Record{type: "List", links: %{"self" => url}}), do: post(url <> "/run")
end
