defmodule PcoApi.RecordAssociation do
  defmacro linked_association(name) do
    quote do
      def unquote(:"#{name}")([]), do: []
      def unquote(:"#{name}")(%PcoApi.Record{} = record) do
        # TODO: error handling when the association link doesn't exist
        request(:get, record.links[Atom.to_string(unquote(name))], [])
        |> Enum.map(fn(%{"attributes" => attrs, "id" => id, "links" => links, "type" => type}) ->
          %PcoApi.Record{attributes: attrs, id: id, links: links, type: type}
        end)
      end
      def unquote(:"#{name}")([%PcoApi.Record{} = first | rest]) do
        [unquote(:"#{name}")(first) | unquote(:"#{name}")(rest)]
        |> List.flatten
        |> Enum.dedup
      end
    end
  end
end
