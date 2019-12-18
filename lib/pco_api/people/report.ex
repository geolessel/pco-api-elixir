defmodule PcoApi.People.Report do
  import PcoApi.RecordAssociation
  linked_association(:created_by)
  linked_association(:owner)
  linked_association(:people)
  linked_association(:rules)
  linked_association(:shares)
  linked_association(:updated_by)

  use PcoApi.Actions

  def list(params) when is_list(params), do: get(params, "reports")

  def get(id) when is_integer(id), do: get("reports/#{id}")

  def create(%PcoApi.Record{attributes: _, type: "Report"} = record),
    do: create(record, "reports")

  def self(%PcoApi.Record{type: "Report", id: id}), do: get("reports/#{id}")

  def new(attrs) when is_list(attrs), do: new(attrs, "Report")
end
