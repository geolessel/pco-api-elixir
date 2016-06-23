defmodule PcoApi.People.List.Rule.Result do

  use PcoApi.Actions, only: [:list, :get, :self]
  import PcoApi.RecordAssociation
  linked_association :person

  @doc """
  TODO: EXPAND
  Gets a list of results for a particular Rule.

  Requires a Rule record with a links attribute.
  """
  def list(%PcoApi.Record{type: "Rule", links: %{"results" => url}}), do: get(url)

  def get(%PcoApi.Record{type: "Rule", links: %{"results" => url}}, id), do: get("#{url}/#{id}")
end
