defmodule PcoApi.People.Person do
  use PcoApi.Actions

  endpoint "https://api.planningcenteronline.com/people/v2/people/"
  linked_association :addresses
  linked_association :apps
  linked_association :connnected_people
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

  def get, do: get("")
  def get(url) when is_binary(url), do: request(:get, url, []) |> new
  def get(params, url) when is_list(params), do: request(:get, url, params) |> new

  def new(results) when is_list(results), do: results |> Enum.map(&(&1 |> new))
  def new(%{"id" => id, "links" => links, "attributes" => attrs, "type" => type}) do
    %PcoApi.Record{id: id, links: links, attributes: attrs, type: type}
  end
end
