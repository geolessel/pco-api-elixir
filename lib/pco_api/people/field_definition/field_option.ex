defmodule PcoApi.People.FieldDefinition.FieldOption do
  use PcoApi.Actions

  def list(%PcoApi.Record{type: "FieldDefinition", links: %{"field_options" => url}}),
    do: get(url)

  def list(%PcoApi.Record{type: "FieldDefinition", id: id}),
    do: get("field_definitions/#{id}/field_options")

  def get(%PcoApi.Record{type: "FieldDefinition", links: %{"field_options" => url}}, id),
    do: get("#{url}/#{id}")

  def get(%PcoApi.Record{type: "FieldDefinition", id: def_id}, id),
    do: get("field_definitions/#{def_id}/field_options/#{id}")

  def new(attrs) when is_list(attrs), do: new(attrs, "FieldOption")

  def create(
        %PcoApi.Record{type: "FieldDefinition", id: id},
        %PcoApi.Record{type: "FieldOption"} = record
      ),
      do: create(record, "field_definitions/#{id}/field_options")

  def create(%PcoApi.Record{type: "FieldOption"} = record, %PcoApi.Record{
        type: "FieldDefinition",
        id: id
      }),
      do: create(record, "field_definitions/#{id}/field_options")
end
