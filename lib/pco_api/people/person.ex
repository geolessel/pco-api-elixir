defmodule PcoApi.People.Person do
  import PcoApi.RecordAssociation
  linked_association :addresses
  linked_association :apps
  linked_association :connected_people
  linked_association :emails
  linked_association :field_data
  linked_association :household_memberships
  linked_association :households
  linked_association :inactive_reason
  linked_association :marital_status
  linked_association :message_groups
  linked_association :messages
  linked_association :name_prefix
  linked_association :name_suffix
  linked_association :phone_numbers
  linked_association :school
  linked_association :social_profiles

  use PcoApi.Actions

  def list(params) when is_list(params), do: get(params, "people")

  def get(id) when is_integer(id), do: get("people/#{id}")

  def create(%PcoApi.Record{attributes: _, type: _} = record), do: create(record, "people")

  def self(%PcoApi.Record{id: id}), do: get "people/#{id}"

  def new(attrs) when is_list(attrs), do: new(attrs, "Person")
end
