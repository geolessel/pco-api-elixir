defmodule PcoApi.People.Person do
  use PcoApi.Actions
  endpoint "people/v2/people/"
  record_type "Person"

  import PcoApi.RecordAssociation
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
end
