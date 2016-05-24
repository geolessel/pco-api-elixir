defmodule PcoApi.People.Workflow.Card.Note do
  @moduledoc """
  A set of functions to work with WorkflowCardNotes belonging to a WorkflowCard.

  Since a WorkflowCardNote is always associated with a WorkflowCard in Planning Center Online,
  a Record of type "WorkflowCard" is required in order to retrieve that WorkflowCard's
  associated WorkflowCardNotes.
  """

  use PcoApi.Actions
  endpoint "people/v2/workflows/"

  @doc """
  Gets associated WorkflowCard records from a Workflow Record from links.

  ## Example:

      iex> %PcoApi.Record{type: "WorkflowCard", links: %{"notes" => "http://example.com"}} |> Note.get
      %PcoApi.Record{type: "WorkflowCardNote", ...}

  """
  def get(%PcoApi.Record{type: "WorkflowCard", links: %{"notes" => url}}), do: get url

  @doc """
  Gets associated WorkflowCardNotes records from a WorkflowCard Record when no notes link is found.

  Sometimes a record my not include an notes link. This function takes a self link to
  get the associated records.

  ## Example:

      iex> %PcoApi.Record{type: "WorkflowCard", links: %{"self" => "http://example.com"}} |> Note.get
      #%PcoApi.Record{type: "WorkflowCardNote", ...}

  """
  def get(%PcoApi.Record{type: "WorkflowCard", links: %{"self" => url}}), do: get("#{url}/notes")

  @doc """
  Gets a single WorkflowCardNote for a WorkflowCard.

  Requires a WorkflowCard with an notes link and a WorkflowCardNote Id.

  ## Example:

      iex> %PcoApi.Record{type: "WorkflowCard", id: 1, links: %{"notes" => "http://example.com"}} |> Note.get(2)
      %PcoApi.Record{type: "WorkflowCardNote", id: 2} # for WorkflowCard.id == 1

  """
  def get(%PcoApi.Record{type: "WorkflowCard"} = card, id) when is_integer(id), do: get(card, Integer.to_string(id))
  def get(%PcoApi.Record{type: "WorkflowCard", links: %{"notes" => url}}, id), do: get(url <> "/" <> id)

  @doc """
  Gets a single WorkflowCardNote for a WorkflowCard.

  Requires a WorkflowCard with a self link and a WorkflowCardNote Id.

  ## Example:

      iex> %PcoApi.Record{type: "WorkflowCard", id: 1, links: %{"self" => "http://example.com"}} |> Address.get(2)
      %PcoApi.Record{type: "WorkflowCardNote", id: 2} # for Person.id == 1

  """
  def get(%PcoApi.Record{type: "WorkflowCard", links: %{"self" => url}}, id), do: get(url <> "/notes/" <> id)
end
