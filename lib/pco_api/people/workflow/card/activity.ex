# TODO: Fix all the docs
defmodule PcoApi.People.Workflow.Card.Activity do
  @moduledoc """
  A set of functions to work with Activities belonging to a Workflow Card.

  Since an Activity is always associated with a Workflow Card in Planning Center Online,
  a Record of type "WorkflowCard" is required in order to retrieve that Workflow Card's
  associated Activities.
  """

  use PcoApi.Actions
  endpoint "people/v2/workflows/"

  @doc """
  Gets associated Workflow.Card records from a Workflow Record from links.

  ## Example:

      iex> %PcoApi.Record{type: "Person", links: %{"addresses" => "http://example.com"}} |> PcoApi.People.Address.get
      %PcoApi.Record{type: "Address", ...}

  """
  # def get(%PcoApi.Record{type: "Person", links: %{"addresses" => url}}), do: get url
  # def get(%PcoApi.Record{type: "Workflow", links: %{"cards" => url}}), do: get url
  def get(%PcoApi.Record{type: "WorkflowCard", links: %{"activities" => url}}), do: get url

  @doc """
  Gets associated Address records from a Person Record when no address link is found.

  Sometimes a record my not include an address link. This function recreates a URL to
  get the associated records just based off of the Person id.

  ## Example:

      iex> %PcoApi.Record{type: "Person", id: 1} |> PcoApi.People.Address.get
      %PcoApi.Record{type: "Address", id: 1, ...}

  """
  # def get(%PcoApi.Record{type: "Person", id: id}), do: get("people/#{id}/addresses")
  def get(%PcoApi.Record{type: "WorkflowCard", id: id, links: %{"self" => url}}) do
    workflow_id = url |> get_workflow_id
    get("#{workflow_id}/cards/#{id}/activities")
  end

  @doc """
  Gets a single Address for a Person.

  Requires a Person with an ID and an Address Id.

  ## Example:

      iex> %PcoApi.Record{type: "Person", id: 1} |> Address.get(2)
      %PcoApi.Record{type: "Address", id: 2} # for Person.id == 1

  """
  # def get(%PcoApi.Record{type: "Person", id: person_id}, id), do: get("people/#{person_id}/addresses/#{id}")
  def get(%PcoApi.Record{type: "WorkflowCard", links: %{"activities" => url}}, id) do
    get(url <> "/" <> id)
  end

  @doc """
  Gets a single Address for a Person.

  Requires a Person with an ID and an Address Id.

  ## Example:

      iex> %PcoApi.Record{type: "Person", id: 1} |> Address.get(2)
      %PcoApi.Record{type: "Address", id: 2} # for Person.id == 1

  """
  def get(card, id) when is_integer(id), do: get(card, Integer.to_string(id))
  def get(%PcoApi.Record{type: "WorkflowCard", links: %{"self" => url}}, id) do
    get(url <> "/activities/" <> id)
  end

  defp get_workflow_id(url) do
    [_, workflow_id] = Regex.run(~r/workflows\/(.*)\/cards/, url)
    workflow_id
  end
end
