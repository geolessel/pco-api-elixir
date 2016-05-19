defmodule PcoApi.People.Workflow.Card do
  @moduledoc """
  GET WorkflowSteps
  """
  use PcoApi.Actions
  import PcoApi.RecordAssociation

  endpoint "people/v2/workflows/"

  linked_association :activities
  linked_association :notes
end
