defmodule PcoApi.People.Workflow do
  use PcoApi.Actions
  import PcoApi.RecordAssociation

  endpoint "people/v2/workflows/"

  linked_association :cards
  linked_association :steps
end
