defmodule PcoApi.People.FieldDefinition do
  @moduledoc false

  use PcoApi.Actions
  import PcoApi.RecordAssociation
  linked_association(:field_options)
  linked_association(:tab)

  def list(params) when is_list(params), do: get(params, "field_definitions")

  def get(id) when is_integer(id), do: get("field_definitions/#{id}")

  def new(attrs) when is_list(attrs), do: new(attrs, "FieldDefinition")

  def create(%PcoApi.Record{type: "FieldDefinition"} = record),
    do: create(record, "field_definitions")
end
