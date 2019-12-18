defmodule PcoApi.People.SchoolOption do
  import PcoApi.RecordAssociation
  linked_association(:promotes_to_school)

  use PcoApi.Actions
  # endpoint "people/v2/school_options/"
  def list(params) when is_list(params), do: get(params, "school_options")

  def get(id) when is_integer(id), do: get("school_options/#{id}")

  def self(%PcoApi.Record{id: id}), do: get("school_options/#{id}")

  def create(%PcoApi.Record{type: "SchoolOption"} = record), do: create(record, "school_options")

  def new(attrs) when is_list(attrs), do: new(attrs, "SchoolOption")
end
