defmodule PcoApi.People.Workflow do
  @moduledoc """
  Access Workflows, WorkflowCards, WorkflowCardActivities, WorkflowCardNotes,
  WorkflowSteps, and WorkflowTasks
  """
  use PcoApi.Actions

  endpoint "https://api.planningcenteronline.com/people/v2/workflows/"

  @key_to_url %{
    card_id: "/cards/",
    step_id: "/steps/",
    activity_id: "/activities/",
    note_id: "/notes/",
    task_id: "/tasks/",
  }

  def get(id, params) when is_list(params), do: get(id, Map.new(params))

  def get(id, params) do
    params
    |> Enum.reduce(id, fn({k, v}, acc) -> build_url(acc, k, v) end)
    # |> do_get(params)
  end

  def activities(id, params \\ []), do: get(id, Map.new([{:activity_id, ""} | params]))
  def cards(id, params \\ []), do: get(id, Map.new([{:card_id, ""} | params]))
  def notes(id, params \\ []), do: get(id, Map.new([{:note_id, ""} | params]))
  def steps(id, params \\ []), do: get(id, Map.new([{:step_id, ""} | params]))
  def tasks(id, params \\ []), do: get(id, Map.new([{:task_id, ""} | params]))

  def build_url(url_str, key, id) do
    case @key_to_url[key] do
      nil -> url_str
      url -> url_str <> url <> id
    end
  end

  # use PcoApi.Actions
  #
  # endpoint "https://api.planningcenteronline.com/people/v2/workflows/"

end
