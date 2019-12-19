defmodule PcoApi.People.Household.Membership do
  @moduledoc false

  use PcoApi.Actions
  import PcoApi.RecordAssociation
  linked_association(:household)
  linked_association(:person)

  def list(%PcoApi.Record{type: "Household", links: %{"household_memberships" => url}}),
    do: get(url)

  def list(%PcoApi.Record{type: "Household", id: id}),
    do: get("households/#{id}/household_memberships")

  def get(%PcoApi.Record{type: "Household", links: %{"household_memberships" => url}}, id),
    do: get("#{url}/#{id}")

  def new(attrs) when is_list(attrs), do: new(attrs, "HouseholdMembership")
end
