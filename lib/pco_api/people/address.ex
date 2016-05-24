defmodule PcoApi.People.Address do
  @moduledoc """
  A set of functions to work with Addresses belonging to a Person.

  Since an Address is always associated with a Person in Planning Center Online,
  a Record of type "Person" is required in order to retrieve that Person's
  associated Addresses.
  """

  use PcoApi.Actions
  endpoint "people/v2/"

  @doc """
  Gets associated Address records from a Person Record from links.

  ## Example:

      iex> %PcoApi.Record{type: "Person", links: %{"addresses" => "http://example.com"}} |> PcoApi.People.Address.get
      %PcoApi.Record{type: "Address", ...}

  """
  def get(%PcoApi.Record{type: "Person", links: %{"addresses" => url}}), do: get url

  @doc """
  Gets associated Address records from a Person Record when no address link is found.

  Sometimes a record may not include an address link. This function recreates a URL to
  get the associated records just based off of the Person id.

  ## Example:

      iex> %PcoApi.Record{type: "Person", id: 1} |> PcoApi.People.Address.get
      %PcoApi.Record{type: "Address", id: 1, ...}

  """
  def get(%PcoApi.Record{type: "Person", id: id}), do: get("people/#{id}/addresses")

  @doc """
  Gets a single Address for a Person.

  Requires a Person with an ID and an Address Id.

  ## Example:

      iex> %PcoApi.Record{type: "Person", id: 1} |> Address.get(2)
      %PcoApi.Record{type: "Address", id: 2} # for Person.id == 1

  """
  def get(%PcoApi.Record{type: "Person", id: person_id}, id), do: get("people/#{person_id}/addresses/#{id}")
end
