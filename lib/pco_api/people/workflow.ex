defmodule PcoApi.People.Workflow do
  @moduledoc """
  GET Workflows, WorkflowCards, and WorkflowSteps
  """
  use PcoApi.Actions
  import PcoApi.RecordAssociation

  endpoint "people/v2/workflows/"

  linked_association :steps
  linked_association :cards
end
