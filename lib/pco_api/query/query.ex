defmodule PcoApi.Query do
  def where({_, _} = param), do: where([], param)
  def where(params, {attr, value}) when is_list(params) do
    add_param(params, {"where[#{attr}]", value})
  end

  defp add_param(params, param) do
    [param | params]
  end
end
