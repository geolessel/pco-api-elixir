defmodule PcoApi.People.Tab do
  use PcoApi.Actions
  endpoint "people/v2/tabs/"

  import PcoApi.RecordAssociation
  linked_association :field_definitions
end
