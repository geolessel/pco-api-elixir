defmodule PcoApi.People.Workflow do
  @moduledoc """
  Access Workflows, WorkflowCards, WorkflowCardActivities, WorkflowCardNotes, WorkflowSteps, and WorkflowTasks
  """

  def get(url_str, [{:card_id, card_id} | params]) do
    url_str |> add_card_url(card_id) |> get(params)
  end

  def get(url_str, [{:step_id, step_id} | params]) do
    url_str |> add_step_url(card_id) |> get(params)
  end

  def get(url_str, [{:note_id, note_id} | params]) do
    url_str |> add_note_url(note_id) |> get(params)
  end

  def get(url_str, [{:activity_id, activity_id} | params]) do
    url_str |> add_activity_url(activity_id) |> get(params)
  end

  def get(url_str, [{:task_id, task_id} | params]) do
    url_str |> add_task_url(task_id) |> get(params)
  end

  def activities(url_str, [{:card_id, card_id} | params]) do
    url_str |> add_card_url(card_id) |> add_activity_url("") |> get(params)
  end

  def notes(url_str, [{:card_id, card_id} | params]) do
    url_str |> add_card_url(card_id) |> add_note_url("") |> get(params)
  end

  def steps(url_str, params \\ []) do
    url_str |> add_step_url("") |> get(params)
  end

  def tasks(url_str, [{:card_id, card_id} | params]) do
    url_str |> add_card_url(card_id) |> add_task_url |> get(params)
  end

  defp add_card_url(url_str, card_id \\ ""),
    do: url_str <> "/cards/" <> card_id
  defp add_step_url(url_str, step_id \\ ""),
    do: url_str <> "/steps/" <> step_id
  defp add_note_url(url_str, note_id \\ ""),
    do: url_str <> "/notes/" <> note_id
  defp add_activity_url(url_str, activity_id \\ ""),
    do: url_str <> "/activities/" <> activity_id
  defp add_task_url(url_str, task_id \\ ""),
    do: url_str <> "/tasks/" <> task_id

  use PcoApi.Actions

  endpoint "https://api.planningcenteronline.com/people/v2/workflows/"
end
