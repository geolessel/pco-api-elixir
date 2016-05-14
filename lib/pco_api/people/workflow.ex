defmodule PcoApi.People.Workflow do
  @moduledoc """
  Let's you access Workflows, WorkflowCards, WorkflowCardActivities, WorkflowCardNotes, WorkflowSteps, and WorkflowTasks
  """

  # Activity
  def get(id, [{:card_id, card_id}, {:activity_id, activity_id} | params]) do
    id <> "/cards/" <> card_id <> "/activities/" <> activity_id
    |> get(params)
  end

  # Note
  def get(id, [{:card_id, card_id}, {:note_id, note_id} | params]) do
    id <> "/cards/" <> card_id <> "/notes/" <> note_id
    |> get(params)
  end

  # Task
  def get(id, [{:card_id, card_id}, {:task_id, task_id} | params]) do
    id <> "/cards/" <> card_id <> "/tasks/" <> task_id
    |> get(params)
  end

  # Card
  def get(id, [{:card_id, card_id} | params]) do
    id <> "/cards/" <> card_id
    |> get(params)
  end

  # Step
  def get(id, [{:step_id, step_id} | params]) do
    id <> "/steps/" <> step_id
    |> get(params)
  end

  def cards(id, params \\ []) do
    id <> "/cards"
    |> get(params)
  end

  def activities(id, [{:card_id, card_id} | params]) do
    id <> "/cards/" <> card_id <> "/activities"
    |> get(params)
  end

  def notes(id, [{:card_id, card_id} | params]) do
    id <> "/cards/" <> card_id <> "/notes"
    |> get(params)
  end

  def steps(id, params \\ []) do
    id <> "/steps"
    |> get(params)
  end

  def tasks(id, [{:card_id, card_id} | params]) do
    id <> "/cards/" <> card_id <> "/tasks"
    |> get(params)
  end

  use PcoApi.Actions

  endpoint "https://api.planningcenteronline.com/people/v2/workflows/"
end
