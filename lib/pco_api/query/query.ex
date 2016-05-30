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
    prefix_params(params, {"where[#{attr}]", value})
  end

  @doc """
  Creates a list of per_page params to pass on to the api call.

  Returns a List of Tuples.

  ## Examples:

      iex> PcoApi.Query.where(first_name: "John") |> PcoApi.Query.per_page(3)
      [{"per_page", "3"}, {"where[first_name]", "John"}]

  """
  def per_page(value) when is_integer(value), do: per_page([], Integer.to_string(value))
  def per_page(params, value) when is_integer(value), do: per_page(params, Integer.to_string(value))
  def per_page(params, value) when is_binary(value) do
    prefix_params(params, {"per_page", value})
  end

  @doc """
  Creates a List of after params to pass on to the api call.

  Returns a List of Tuples.

  ## Examples:

      iex> PcoApi.Query.per_page(4) |> PcoApi.Query.after_record(4)
      [{"after", "4"}, {"per_page", "4"}]

  """
  def after_record(value) when is_integer(value), do: after_record([], Integer.to_string(value))
  def after_record(params, value) when is_integer(value), do: after_record(params, Integer.to_string(value))
  def after_record(params, value) when is_binary(value) do
      prefix_params(params, {"after", value})
  end

  defp prefix_params(params, param) do
    [param | params]
  end
end
