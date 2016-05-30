defmodule PcoApi.People.SchoolOption do
  use PcoApi.Actions
  endpoint "people/v2/school_options/"

  import PcoApi.RecordAssociation
  linked_association :promotes_to_school
end
