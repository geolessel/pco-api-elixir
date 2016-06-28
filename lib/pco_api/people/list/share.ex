defmodule PcoApi.People.List.Share do
  use PcoApi.Actions, only: [:list, :get]
  import PcoApi.RecordAssociation
  linked_association :person

  def list(%PcoApi.Record{type: "List", links: %{"shares" => url}}), do: get(url)
  def list(%PcoApi.Record{type: "List", id: id}), do: get("lists/#{id}/shares")

  def get(%PcoApi.Record{type: "List", links: %{"shares" => url}}, id), do: get("#{url}/#{id}")
end
