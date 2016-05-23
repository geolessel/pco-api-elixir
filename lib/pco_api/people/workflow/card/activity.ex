defmodule PcoApi.People.Workflow.Card.Activity do
  @moduledoc """
  A set of functions to work with WorkflowCardActivities belonging to a WorkflowCard.

  Since a WorkflowCardActivity is always associated with a WorkflowCard in Planning Center Online,
  a Record of type "WorkflowCard" is required in order to retrieve that WorkflowCard's
  associated WorkflowCardActivities.
  """

  use PcoApi.Actions
  endpoint "people/v2/workflows/"

  @doc """
  Gets associated WorkflowCard records from a Workflow Record from links.

  ## Example:

      iex> %PcoApi.Record{type: "WorkflowCard", links: %{"activities" => "http://example.com"}} |> Activity.get
      %PcoApi.Record{type: "WorkflowCardActivity", ...}

  """
  def get(%PcoApi.Record{type: "WorkflowCard", links: %{"activities" => url}}), do: get url

  @doc """
  Gets associated WorkflowCardActivities records from a WorkflowCard Record when no activities link is found.

  Sometimes a record my not include an activities link. This function takes a self link to
  get the associated records.

  ## Example:

      iex> %PcoApi.Record{type: "WorkflowCard", links: %{"self" => "http://example.com"}} |> Activity.get
      #%PcoApi.Record{type: "WorkflowCardActivity", ...}

  """
  def get(%PcoApi.Record{type: "WorkflowCard", links: %{"self" => url}}), do: get("#{url}/activities")

  @doc """
  Gets a single WorkflowCardActivity for a WorkflowCard.

  Requires a WorkflowCard with an activities link and a WorkflowCardActivity Id.

  ## Example:

      iex> %PcoApi.Record{type: "WorkflowCard", id: 1, links: %{"activities" => "http://example.com"}} |> Activity.get(2)
      %PcoApi.Record{type: "WorkflowCardActivity", id: 2} # for WorkflowCard.id == 1

  """
  def get(%PcoApi.Record{type: "WorkflowCard"}, id) when is_integer(id), do: get(card, Integer.to_string(id))
  def get(%PcoApi.Record{type: "WorkflowCard", links: %{"activities" => url}}, id), do: get(url <> "/" <> id)

  @doc """
  Gets a single WorkflowCardActivity for a WorkflowCard.

  Requires a WorkflowCard with a self link and a WorkflowCardActivity Id.

  ## Example:

      iex> %PcoApi.Record{type: "WorkflowCard", id: 1, links: %{"self" => "http://example.com"}} |> Address.get(2)
      %PcoApi.Record{type: "WorkflowCardActivity", id: 2} # for Person.id == 1

  """
  def get(%PcoApi.Record{type: "WorkflowCard", links: %{"self" => url}}, id), do: get(url <> "/activities/" <> id)
end
