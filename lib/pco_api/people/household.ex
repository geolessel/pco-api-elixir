defmodule PcoApi.People.Household do
  use PcoApi.Actions

  def list(params) when is_list(params), do: get(params, "households")
end
