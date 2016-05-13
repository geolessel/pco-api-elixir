defmodule PcoApi do
  def key do
    Application.get_env(:pco_api, :api_key)
  end

  def secret do
    Application.get_env(:pco_api, :api_secret)
  end
end
