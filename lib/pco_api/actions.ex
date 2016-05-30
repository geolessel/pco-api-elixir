defmodule PcoApi.Actions do
  defmacro __using__(_opts) do
    quote do
      import PcoApi.Actions
      use HTTPoison.Base

      def request(:get, url, params) do
        case get(url, [], params: params, hackney: [basic_auth: {PcoApi.key, PcoApi.secret}]) do
          {:ok, %HTTPoison.Response{status_code: code, body: body}} when (code in 200..299) ->
            cond do
              %{"data" => data} = body -> data
              true -> body
            end
          {:ok, %HTTPoison.Response{body: body}} ->
            %{"errors" => [%{"detail" => detail, "title" => title}]} = body
            raise "Request returned non-200 response. Error: #{title}: #{detail}"
          {:error, _} ->
            raise "PcoApi.People error"
        end
      end

      def get, do: get("")
      def get(id) when is_integer(id), do: get(Integer.to_string(id))
      def get(url) when is_binary(url), do: request(:get, url, []) |> to_record
      def get(params) when is_list(params), do: get(params, "")
      def get(params, url) when is_list(params), do: request(:get, url, params) |> to_record

      def create(%PcoApi.Record{attributes: _, type: _} = record), do: create(record, "")
      def create(%PcoApi.Record{attributes: _, type: _} = record, url) when is_binary(url) do
        # TODO: Error handling for when the record isn't created
        record |> PcoApi.Record.to_json |> create(url)
      end
      def create(json, url) when is_binary(json) do
        case post(url, json, [], hackney: [basic_auth: {PcoApi.key, PcoApi.secret}]) do
          {:ok, %HTTPoison.Response{status_code: code, body: body}} when (code in 200..299) ->
            cond do
              %{"data" => data} = body -> data |> to_record
              true -> body
            end
          {:ok, %HTTPoison.Response{body: body}} ->
            raise "PcoApi ok, but not ok: #{IO.inspect body}"
          {:error, err} ->
            raise "PcoApi error: #{IO.inspect err}"
          _ ->
            # TODO: better error handling
            raise "PcoApi error: post"
        end
      end

      defp to_record(results) when is_list(results), do: results |> Enum.map(&(&1 |> to_record))
      defp to_record(%{"id" => id, "links" => links, "attributes" => attrs, "type" => type}) do
        %PcoApi.Record{id: id, links: links, attributes: attrs, type: type}
      end

      def self(%PcoApi.Record{links: %{"self" => self}}), do: get self
      def self(%PcoApi.Record{id: id}), do: get String.to_integer(id)

      def new(attrs) when is_list(attrs) do
        attrs_map = Enum.into(attrs, %{}, fn({k,v}) -> {Atom.to_string(k), v} end)
        %PcoApi.Record{attributes: attrs_map, type: __MODULE__.type}
      end

      # HTTPoison.Base API

      # if this is a full URL, don't add the endpoint. This allows using direct links.
      def process_url(url) do
        configured_endpoint = __MODULE__.api_endpoint
        endpoint_base = Application.get_env(:pco_api, :endpoint_base)
        case url |> String.starts_with?(endpoint_base) do
          true  -> url
          false -> endpoint_base <> configured_endpoint <> String.replace(url, ~r|^https?://[0-9a-zA-Z:.]+/#{configured_endpoint}|U, "") # enforce the endpoint
        end
      end
      def process_response_body(body), do: body |> Poison.decode!
    end
  end

  defmacro endpoint(url) do
    quote do
      def unquote(:api_endpoint)() do
        unquote(url)
      end
    end
  end

  defmacro record_type(type) do
    quote do
      def unquote(:type)(), do: unquote(type)
    end
  end
end
