defmodule PcoApi.People.List do
  use PcoApi.Actions
  endpoint "people/v2/lists/"

  import PcoApi.RecordAssociation
  linked_association :created_by
  linked_association :owner
  linked_association :people
  linked_association :rules
  linked_association :shares
  linked_association :updated_by
end
