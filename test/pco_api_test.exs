defmodule PcoApiTest do
  use ExUnit.Case
  doctest PcoApi

  # setup do
  #   bypass = Bypass.open
  #   Application.put_env(:pco_api, :endpoint_base, "http://localhost:#{bypass.port}/")
  #   {:ok, bypass: bypass}
  # end
end
