defmodule PcoApi.Actions.Create do
  defmacro __using__(_opts) do
    quote do
      import PcoApi.Actions.Create
      import PcoApi.Record

      def post(url) when is_binary(url), do: create("", url)

      def create(%PcoApi.Record{attributes: _, type: _} = record, url) when is_binary(url) do
        # TODO: Error handling for when the record isn't created
        record |> PcoApi.Record.to_json() |> create(url)
      end

      def create(json, url) when is_binary(json) do
        url
        |> post(json, [], hackney: [basic_auth: {PcoApi.key(), PcoApi.secret()}])
        |> do_create
      end

      defp do_create({:ok, %HTTPoison.Response{status_code: code, body: %{"data" => data}}})
           when code in 200..299 do
        data |> to_record
      end

      defp do_create({:ok, %HTTPoison.Response{status_code: code, body: body}})
           when code in 200..299,
           do: body

      defp do_create({:ok, %HTTPoison.Response{body: body}}),
        do: raise("PcoApi ok, but not ok: #{IO.inspect(body)}")

      defp do_create({:error, err}), do: raise("PcoApi error: #{IO.inspect(err)}")
    end
  end

  defmacro record_type(type) do
    quote do
      def unquote(:type)(), do: unquote(type)
    end
  end
end
