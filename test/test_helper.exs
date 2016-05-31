ExUnit.start()
Application.ensure_all_started(:bypass)

defmodule TestHelper do
  defmodule Fixture do
    def read(filename) do
      File.read!("test/fixtures/#{filename}")
    end

    def dummy do
      File.read!("test/fixtures/dummy.json")
    end
  end
end
