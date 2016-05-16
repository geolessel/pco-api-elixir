defmodule PcoApi.People.Workflow do
  @moduledoc """
  Access Workflows, WorkflowCards, WorkflowCardActivities, WorkflowCardNotes,
  WorkflowSteps, and WorkflowTasks
  """
  use PcoApi.Actions
  import PcoApi.UrlBuilder

  endpoint "https://api.planningcenteronline.com/people/v2/workflows/"

  @url_key %{
    card_id: "/cards/",
    step_id: "/steps/",
    activity_id: "/activities/",
    note_id: "/notes/",
    task_id: "/tasks/",
  }

  def get(id, params) when is_list(params), do: get(id, Map.new(params))

  def get(id, params) do
    params
    |> Map.split([:card_id, :step_id])
    |> Tuple.to_list
    |> Enum.reduce(id, fn(x, acc) -> build_url(x, acc) end)
    |> do_get(params)
  end

  get_plural_function :activity, :activities
  get_plural_function :card, :cards
  get_plural_function :note, :notes
  get_plural_function :step, :steps
  get_plural_function :task, :tasks

  def build_url(map, id) do
    Enum.reduce(map, id, fn({k, v}, acc) -> build_url(acc, k, v) end)
  end

  def build_url(url_str, key, id) do
    case @url_key[key] do
      nil -> url_str
      url -> url_str <> url <> id
    end
  end
end
