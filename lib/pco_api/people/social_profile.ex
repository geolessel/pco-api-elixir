defmodule PcoApi.People.SocialProfile do
  @moduledoc """
  A set of functions to work with Addresses belonging to a Person.

  Since an Address is always associated with a Person in Planning Center Online,
  a Record of type "Person" is required in order to retrieve that Person's
  associated Addresses.
  """

  use PcoApi.Actions
  endpoint "people/v2/"

  import PcoApi.RecordAssociation
  linked_association :person

  def get(%PcoApi.Record{type: "Person", links: %{"social_profiles" => url}}), do: get url
  def get(%PcoApi.Record{type: "Person", id: id}), do: get("people/#{id}/social_profiles")
  def get(%PcoApi.Record{type: "Person", id: person_id}, id), do: get("people/#{person_id}/social_profiles/#{id}")
end
