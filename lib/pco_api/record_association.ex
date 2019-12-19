defmodule PcoApi.RecordAssociation do
  @moduledoc false

  defmacro linked_association(name) do
    quote do
      def unquote(:"#{name}")([]), do: []

      def unquote(:"#{name}")(%PcoApi.Record{} = record) do
        # TODO: error handling when the association link doesn't exist
        unquote(:"#{name}")(request(:get, record.links[Atom.to_string(unquote(name))], []))
      end

      def unquote(:"#{name}")([%PcoApi.Record{} = first | rest]) do
        [unquote(:"#{name}")(first) | unquote(:"#{name}")(rest)]
        |> List.flatten()
        |> Enum.dedup()
      end

      def unquote(:"#{name}")(%{
            "attributes" => attrs,
            "id" => id,
            "links" => links,
            "type" => type
          }) do
        %PcoApi.Record{attributes: attrs, id: id, links: links, type: type}
      end

      def unquote(:"#{name}")(list) when is_list(list) do
        list |> Enum.map(&unquote(:"#{name}")(&1))
      end
    end
  end
end
