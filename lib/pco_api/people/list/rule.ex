defmodule PcoApi.People.List.Rule do
  @moduledoc """
  A set of functions to work with Rules belonging to a List.

  Since a Rule is always associated with a List in Planning Center Online,
  a Record of type "List" is required in order to retrieve that List's
  associated Rules.
  """

  use PcoApi.Actions

  import PcoApi.RecordAssociation
  linked_association(:conditions)
  linked_association(:results)

  @doc """
  Gets associated Rule records from a List Record from links.

  ## Example:

      iex> %PcoApi.Record{type: "List", links: %{"rules" => "http://example.com"}} |> PcoApi.People.Rule.get
      %PcoApi.Record{type: "Rule", ...}

  """
  def list(%PcoApi.Record{type: "List", links: %{"rules" => url}}), do: get(url)

  @doc """
  Gets associated Rule records from a List Record when no rules link is found.

  Sometimes a record may not include a rules link. This function recreates a URL to
  get the associated records just based off of the List Id.

  ## Example:

      iex> %PcoApi.Record{type: "List", id: 1} |> PcoApi.People.Rule.get
      %PcoApi.Record{type: "Rule", id: 1, ...}

  """
  def list(%PcoApi.Record{type: "List", id: id}), do: get("lists/#{id}/rules")

  @doc """
  Gets a single Rule for a List.

  Requires a List Record with an ID and a Rule Id.

  ## Example:

      iex> %PcoApi.Record{type: "List", id: 1} |> PcoApi.People.Rule.get(2)
      %PcoApi.Record{type: "Rule", id: 2} # for List.id == 1

  """
  def get(%PcoApi.Record{type: "List", id: list_id}, id), do: get("lists/#{list_id}/rules/#{id}")
end
