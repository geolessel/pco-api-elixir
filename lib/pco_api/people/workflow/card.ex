defmodule PcoApi.People.Workflow.Card do
  @moduledoc """
  A set of functions to work with WorkflowCards belonging to a Workflow.

  Since a WorkflowCard is always associated with a Workflow in Planning Center Online,
  a Record of type "Workflow" is required in order to retrieve that Workflow's
  associated WorkflowCards.
  """

  use PcoApi.Actions
  endpoint "people/v2/"

  import PcoApi.RecordAssociation
  linked_association :activities
  linked_association :assignee
  linked_association :notes
  linked_association :person

  @doc """
  Gets associated WorkflowCard records from a Workflow Record from links.

  ## Example:

      iex> %PcoApi.Record{type: "Workflow", links: %{"cards" => "http://example.com"}} |> Card.get
      %PcoApi.Record{type: "WorkflowCard", ...}

  """
  def get(%PcoApi.Record{type: "Workflow", links: %{"cards" => url}}), do: get url

  @doc """
  Gets associated WorkflowCard records from a Workflow Record when no cards link is found.

  Sometimes a record may not include a cards link. This function recreates a URL to
  get the associated records just based off of the Workflow Id.

  ## Example:

      iex> %PcoApi.Record{type: "Workflow", id: 1} |> Card.get
      %PcoApi.Record{type: "WorkflowCard", id: 1, ...}

  """
  def get(%PcoApi.Record{type: "Workflow", id: id}), do: get("workflows/#{id}/cards")

  @doc """
  Gets a single WorkflowCard for a Workflow.

  Requires a Workflow Record with an ID and a WorkflowCard Id.

  ## Example:

      iex> %PcoApi.Record{type: "Workflow", id: 1} |> Card.get(2)
      %PcoApi.Record{type: "WorkflowCard", id: 2} # for Workflow.id == 1

  """
  def get(%PcoApi.Record{type: "Workflow", id: workflow_id}, id), do: get("workflows/#{workflow_id}/cards/#{id}")
end
