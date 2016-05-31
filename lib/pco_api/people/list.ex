defmodule PcoApi.People.List do
  use PcoApi.Actions
  import PcoApi.RecordAssociation

  endpoint "people/v2/lists/"

  linked_association :created_by
  linked_association :owner
  linked_association :people
  linked_association :rules
  linked_association :shares
  linked_association :updated_by
end
