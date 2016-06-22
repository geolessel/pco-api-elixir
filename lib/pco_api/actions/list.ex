defmodule PcoApi.Actions.List do
  defmacro __using__(_opts) do
    quote do
      import PcoApi.Actions.List
      import PcoApi.Record

      def list, do: list([])
    end
  end
end
