defmodule PcoApi.UrlBuilder do
  defmacro get_plural_function(name, plural_name) do
    quote do
      def unquote(:"#{plural_name}")(id, params \\ []) do
        get(id, Map.new([{unquote(:"#{name}_id"), ""} | params]))
      end
    end
  end
end
