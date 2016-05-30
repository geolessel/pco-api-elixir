defmodule PcoApi.People.Workflow do
  use PcoApi.Actions
  endpoint "people/v2/workflows/"

  import PcoApi.RecordAssociation
  linked_association :cards
  linked_association :steps
end
