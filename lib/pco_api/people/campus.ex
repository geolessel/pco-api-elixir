defmodule PcoApi.People.Campus do
  @moduledoc """
  A set of functions dealing with Organization Campuses.

  For these get functions to work, an Organization Record is not required
  as a param. This is because Planning Center Online uses the currently
  logged in user's Organization information.
  """

  use PcoApi.Actions

  def list, do: list([])
  def list(params) when is_list(params), do: get(params, "campuses")

  def get(id) when is_integer(id), do: get("campuses/#{id}")
end
