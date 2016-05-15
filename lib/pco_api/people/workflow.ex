defmodule PcoApi.People.Workflow do
  @moduledoc """
  Let's you access Workflows, WorkflowCards, WorkflowCardActivities, WorkflowCardNotes, WorkflowSteps, and WorkflowTasks
  """
  use PcoApi.Actions

  endpoint "https://api.planningcenteronline.com/people/v2/workflows/"

  def get(id, params) when is_list(params), do: get(id, Map.new(params))

  def get(id, %{card_id: card_id, activity_id: activity_id} = params) do
    url_str = id <> "/cards/" <> card_id <> "/activities/" <> activity_id
    get(url_str, params)
  end

  def get(id, %{card_id: card_id, note_id: note_id} = params) do
    url_str = id <> "/cards/" <> card_id <> "/notes/" <> note_id
    get(url_str, params)
  end

  def get(id, %{card_id: card_id, task_id: task_id} = params) do
    url_str = id <> "/cards/" <> card_id <> "/tasks/" <> task_id
    get(url_str, params)
  end

  def get(id, %{card_id: card_id} = params) do
    url_str = id <> "/cards/" <> card_id
    get(url_str, params)
  end

  def get(id, %{step_id: step_id} = params) do
    url_str = id <> "/steps/" <> step_id
    get(url_str, params)
  end

  def cards(id, params \\ []) do
    url_str = id <> "/cards"
    get(url_str, params)
  end

  def steps(id, params \\ []) do
    url_str = id <> "/steps"
    get(url_str, params)
  end

  def activities(id, params) when is_list(params), do: activities(id, Map.new(params))
  def activities(id, %{card_id: card_id} = params) do
    url_str = id <> "/cards/" <> card_id <> "/activities"
    get(url_str, params)
  end

  def notes(id, params) when is_list(params), do: notes(id, Map.new(params))
  def notes(id, %{card_id: card_id} = params) do
    url_str = id <> "/cards/" <> card_id <> "/notes"
    get(url_str, params)
  end

  def tasks(id, params) when is_list(params), do: tasks(id, Map.new(params))
  def tasks(id, %{card_id: card_id} = params) do
    url_str = id <> "/cards/" <> card_id <> "/tasks"
    get(url_str, params)
  end
end
