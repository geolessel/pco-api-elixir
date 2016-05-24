defmodule PcoApi.People.Workflow.Step do
  @moduledoc """
  A set of functions to work with WorkflowSteps belonging to a Workflow.

  Since a WorkflowStep is always associated with a Workflow in Planning Center Online,
  a Record of type "Workflow" is required in order to retrieve that Workflow's
  associated WorkflowSteps.
  """

  use PcoApi.Actions
  endpoint "people/v2/workflows/"

  @doc """
  Gets associated WorkflowStep records from a Workflow Record from links.

  ## Example:

      iex> %PcoApi.Record{type: "Workflow", links: %{"steps" => "http://example.com"}} |> Step.get
      %PcoApi.Record{type: "WorkflowStep", ...}

  """
  def get(%PcoApi.Record{type: "Workflow", links: %{"steps" => url}}), do: get url

  @doc """
  Gets associated WorkflowStep records from a Workflow Record when no steps link is found.

  Sometimes a record may not include a steps link. This function recreates a URL to
  get the associated records just based off of the Workflow Id.

  ## Example:

      iex> %PcoApi.Record{type: "Workflow", id: 1} |> Step.get
      %PcoApi.Record{type: "WorkflowStep", id: 1, ...}

  """
  def get(%PcoApi.Record{type: "Workflow", id: id}), do: get("#{id}/steps")

  @doc """
  Gets a single WorkflowStep for a Workflow.

  Requires a Workflow Record with an ID and a WorkflowStep Id.

  ## Example:

      iex> %PcoApi.Record{type: "Workflow", id: 1} |> Step.get(2)
      %PcoApi.Record{type: "WorkflowStep", id: 2} # for Workflow.id == 1

  """
  def get(%PcoApi.Record{type: "Workflow", id: workflow_id}, id), do: get("#{workflow_id}/steps/#{id}")
end
