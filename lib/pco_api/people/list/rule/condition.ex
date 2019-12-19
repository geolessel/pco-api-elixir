defmodule PcoApi.People.List.Rule.Condition do
  @moduledoc false

  use PcoApi.Actions, only: [:list, :get]
  import PcoApi.RecordAssociation
  linked_association(:results)

  def list(%PcoApi.Record{type: "Rule", links: %{"conditions" => url}}), do: get(url)

  def get(%PcoApi.Record{type: "Rule", links: %{"conditions" => url}}, id),
    do: get("#{url}/#{id}")
end
