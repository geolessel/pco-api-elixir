defmodule PcoApi.People.Workflow.Card.Task do
  @moduledoc """
  A set of functions to work with WorkflowTasks belonging to a WorkflowCard.

  Since a WorkflowTask is always associated with a WorkflowCard in Planning Center Online,
  a Record of type "WorkflowCard" is required in order to retrieve that WorkflowCard's
  associated WorkflowTasks.
  """

  use PcoApi.Actions
  endpoint "people/v2/workflows/"

  @doc """
  Gets associated WorkflowCard records from a Workflow Record from links.

  ## Example:

      iex> %PcoApi.Record{type: "WorkflowCard", links: %{"tasks" => "http://example.com"}} |> Task.get
      %PcoApi.Record{type: "WorkflowTask", ...}

  """
  def get(%PcoApi.Record{type: "WorkflowCard", links: %{"tasks" => url}}), do: get url

  @doc """
  Gets associated WorkflowTasks records from a WorkflowCard Record when no tasks link is found.

  Sometimes a record my not include a tasks link. This function takes a self link to
  get the associated records.

  ## Example:

      iex> %PcoApi.Record{type: "WorkflowCard", links: %{"self" => "http://example.com"}} |> Task.get
      #%PcoApi.Record{type: "WorkflowTask", ...}

  """
  def get(%PcoApi.Record{type: "WorkflowCard", links: %{"self" => url}}), do: get("#{url}/tasks")

  @doc """
  Gets a single WorkflowTask for a WorkflowCard.

  Requires a WorkflowCard with a tasks link and a WorkflowTask Id.

  ## Example:

      iex> %PcoApi.Record{type: "WorkflowCard", id: 1, links: %{"tasks" => "http://example.com"}} |> Task.get(2)
      %PcoApi.Record{type: "WorkflowTask", id: 2} # for WorkflowCard.id == 1

  """
  def get(%PcoApi.Record{type: "WorkflowCard"} = card, id) when is_integer(id), do: get(card, Integer.to_string(id))
  def get(%PcoApi.Record{type: "WorkflowCard", links: %{"tasks" => url}}, id), do: get(url <> "/" <> id)

  @doc """
  Gets a single WorkflowTask for a WorkflowCard.

  Requires a WorkflowCard with a self link and a WorkflowTask Id.

  ## Example:

      iex> %PcoApi.Record{type: "WorkflowCard", id: 1, links: %{"self" => "http://example.com"}} |> Address.get(2)
      %PcoApi.Record{type: "WorkflowTask", id: 2} # for Person.id == 1

  """
  def get(%PcoApi.Record{type: "WorkflowCard", links: %{"self" => url}}, id), do: get(url <> "/tasks/" <> id)
end
