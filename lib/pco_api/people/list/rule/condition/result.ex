defmodule PcoApi.People.List.Rule.Condition.Result do
  use PcoApi.Actions, only: [:list, :get, :self]
  import PcoApi.RecordAssociation
  linked_association :person

  def list(%PcoApi.Record{type: "Condition", links: %{"results" => url}}), do: get(url)

  def get(%PcoApi.Record{type: "Condition", links: %{"results" => url}}, id), do: get("#{url}/#{id}")
end
