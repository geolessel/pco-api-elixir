defmodule PcoApi.People.Rule do
  @moduledoc """
  A set of functions to work with Rules belonging to a List.

  Since a Rule is always associated with a List in Planning Center Online,
  a Record of type "List" is required in order to retrieve that List's
  associated Rules.
  """

  use PcoApi.Actions
  endpoint "people/v2/"

  import PcoApi.RecordAssociation
  linked_association :conditions
  linked_association :results

  @doc """
  Gets associated Rule records from a List Record from links.

  ## Example:

      iex> %PcoApi.Record{type: "List", links: %{"cards" => "http://example.com"}} |> PcoApi.People.List.Card.get
      %PcoApi.Record{type: "Rule", ...}

  """
  def get(%PcoApi.Record{type: "List", links: %{"cards" => url}}), do: get url

  @doc """
  Gets associated Rule records from a List Record when no cards link is found.

  Sometimes a record may not include a cards link. This function recreates a URL to
  get the associated records just based off of the List Id.

  ## Example:

      iex> %PcoApi.Record{type: "List", id: 1} |> PcoApi.People.List.Card.get
      %PcoApi.Record{type: "Rule", id: 1, ...}

  """
  def get(%PcoApi.Record{type: "List", id: id}), do: get("lists/#{id}/cards")

  @doc """
  Gets a single Rule for a List.

  Requires a List Record with an ID and a Rule Id.

  ## Example:

      iex> %PcoApi.Record{type: "List", id: 1} |> PcoApi.People.List.Card.get(2)
      %PcoApi.Record{type: "Rule", id: 2} # for List.id == 1

  """
  def get(%PcoApi.Record{type: "List", id: list_id}, id), do: get("lists/#{list_id}/cards/#{id}")
end
