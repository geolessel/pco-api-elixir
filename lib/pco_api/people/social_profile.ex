defmodule PcoApi.People.SocialProfile do
  @moduledoc """
  A set of functions to work with SocialProfile records belonging to a Person.

  Since a SocialProfile is always associated with a Person in Planning Center Online,
  a Record of type "Person" is required in order to retrieve that Person's
  associated SocialProfile records.
  """

  use PcoApi.Actions

  import PcoApi.RecordAssociation
  linked_association :person

  @doc """
  Gets associated SocialProfile records from a Person Record from links.

  ## Example:

      iex> %PcoApi.Record{type: "Person", links: %{"social_profiles" => "http://example.com"}} |> PcoApi.People.SocialProfile.get
      %PcoApi.Record{type: "SocialProfile", ...}

  """
  def list(%PcoApi.Record{type: "Person", links: %{"social_profiles" => url}}), do: get url

  @doc """
  Gets associated SocialProfile records from a Person record when no cards link is found.

  Sometimes a record may not include a cards link. This function recreates a URL to
  get the associated records just based off of the Person Id.

  ## Example:

      iex> %PcoApi.Record{type: "Person", id: 1} |> PcoApi.People.SocialProfile.get
      %PcoApi.Record{type: "SocialProfile", id: 1, ...}

  """
  def list(%PcoApi.Record{type: "Person", id: id}), do: get("people/#{id}/social_profiles")

  @doc """
  Gets a single SocialProfile for a Person.

  Requires a Person record with an ID and a SocialProfile Id.

  ## Example:

      iex> %PcoApi.Record{type: "Person", id: 1} |> PcoApi.People.SocialProfile.get(2)
      %PcoApi.Record{type: "SocialProfile", id: 2} # for Person.id == 1

  """
  def get(%PcoApi.Record{type: "Person", id: person_id}, id), do: get("people/#{person_id}/social_profiles/#{id}")

  def create(%PcoApi.Record{type: "Person"} = person, %PcoApi.Record{type: "SocialProfile"} = record), do: create(record, "people/#{person.id}/social_profiles")

  def self(%PcoApi.Record{type: "SocialProfile", links: %{"self" => url}}), do: get url

  def new(attrs) when is_list(attrs), do: new(attrs, "SocialProfile")
end
