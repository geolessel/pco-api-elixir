defmodule PcoApi.People.Person.FieldDatum do
  use PcoApi.Actions
  import PcoApi.RecordAssociation
  linked_association :field_definition
  linked_association :field_option
  linked_association :tab
  
  def list(%PcoApi.Record{type: "Person", links: %{"field_data" => url}}), do: get(url)
  def list(%PcoApi.Record{type: "Person", id: id}), do: get("people/#{id}/field_data")

  def get(%PcoApi.Record{type: "Person", links: %{"field_data" => url}}, id), do: get("#{url}/#{id}")
  def get(%PcoApi.Record{type: "Person", id: person_id}, id), do: get("people/#{person_id}/field_data/#{id}")

  def new(attrs) when is_list(attrs), do: new(attrs, "FieldDatum")

  def create(%PcoApi.Record{type: "Person", id: id}, %PcoApi.Record{type: "FieldDatum"} = record), do: create(record, "people/#{id}/field_data")
  def create(%PcoApi.Record{type: "FieldDatum"} = record, %PcoApi.Record{type: "Person", id: id}), do: create(record, "people/#{id}/field_data")
end
