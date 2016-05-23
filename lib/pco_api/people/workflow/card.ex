# TODO: Fix all the docs
defmodule PcoApi.People.Workflow.Card do
  @moduledoc """
  A set of functions to work with WorkflowCards belonging to a Workflow.

  Since a WorkflowCard is always associated with a Workflow in Planning Center Online,
  a Record of type "Workflow" is required in order to retrieve that Workflow's
  associated WorkflowCards.
  """

  use PcoApi.Actions
  import PcoApi.RecordAssociation
  endpoint "people/v2/workflows/"

  linked_association :activities
  linked_association :notes

  @doc """
  Gets associated Workflow.Card records from a Workflow Record from links.

  ## Example:

      iex> %PcoApi.Record{type: "Person", links: %{"addresses" => "http://example.com"}} |> PcoApi.People.Address.get
      %PcoApi.Record{type: "Address", ...}

  """
  # def get(%PcoApi.Record{type: "Person", links: %{"addresses" => url}}), do: get url
  def get(%PcoApi.Record{type: "Workflow", links: %{"cards" => url}}), do: get url

  @doc """
  Gets associated Address records from a Person Record when no address link is found.

  Sometimes a record my not include an address link. This function recreates a URL to
  get the associated records just based off of the Person id.

  ## Example:

      iex> %PcoApi.Record{type: "Person", id: 1} |> PcoApi.People.Address.get
      %PcoApi.Record{type: "Address", id: 1, ...}

  """
  # def get(%PcoApi.Record{type: "Person", id: id}), do: get("people/#{id}/addresses")
  def get(%PcoApi.Record{type: "Workflow", id: id}), do: get("#{id}/cards")

  @doc """
  Gets a single Address for a Person.

  Requires a Person with an ID and an Address Id.

  ## Example:

      iex> %PcoApi.Record{type: "Person", id: 1} |> Address.get(2)
      %PcoApi.Record{type: "Address", id: 2} # for Person.id == 1

  """
  # def get(%PcoApi.Record{type: "Person", id: person_id}, id), do: get("people/#{person_id}/addresses/#{id}")
  def get(%PcoApi.Record{type: "Workflow", id: workflow_id}, id), do: get("#{workflow_id}/cards/#{id}")
end
