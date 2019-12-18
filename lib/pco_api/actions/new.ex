defmodule PcoApi.Actions.New do
  @moduledoc false

  defmacro __using__(_opts) do
    quote do
      import PcoApi.Actions.New

      def new(attrs, type) when is_map(attrs) and is_binary(type) do
        %PcoApi.Record{attributes: attrs, type: type}
      end

      def new(attrs, type) when is_list(attrs) and is_binary(type) do
        attrs_map = Enum.into(attrs, %{}, fn {k, v} -> {Atom.to_string(k), v} end)
        %PcoApi.Record{attributes: attrs_map, type: type}
      end
    end
  end
end
