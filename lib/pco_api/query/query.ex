defmodule PcoApi.Query do
  @moduledoc """
  A set of functions to assist in composing queries to the API.
  """

  @doc """
  Creates a list of where params to pass onto the api call.
  Returns a List of Tuples.

  ## Examples

      iex> PcoApi.Query.where(first_name: "Geoffrey")
      [{"where[first_name]", "Geoffrey"}]

      iex> PcoApi.Query.where(first_name: "Geoffrey") |> PcoApi.Query.where(last_name: "Lessel")
      [{"where[last_name]", "Lessel"}, {"where[first_name]", "Geoffrey"}]

  """
  def where(param) when is_list(param), do: where([], param)
  def where(params, param) when is_list(params) do
    {attr, value} = param |> hd
    add_param(params, {"where[#{attr}]", value})
  end

  defp add_param(params, param) do
    [param | params]
  end
end
