defmodule PcoApi.People do
  @moduledoc """
  A set of functions operating on the root path of the People API.
  """

  use PcoApi.Actions

  endpoint "people/v2/"

  @doc """
  Gets the Person record for the logged in user.

  ## Example

      iex> PcoApi.People.me
      %PcoApi.Record{}

  """
  def me do
    get("me")
  end

  @doc """
  Builds and gets a specific path to a resource.
  This is useful when you know the specific ids of a deeply nested resource
  of the API but don't necessarily have an already constructed link.

  ## Examples

      To get a workflow's card's activities:
      iex> PcoApi.People.resource(workflow: 1, card: 2, activities: 3)
      %PcoApi.Record{id: 3, type: "WorkflowCardActivity"}

  """
  def resource(params) do
    params
    |> Enum.map(fn({k,v}) -> "#{k}/#{v}" end)
    |> Enum.join("/")
    |> get
  end
end
