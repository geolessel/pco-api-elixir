defmodule PcoApi.People.Workflow do
  @moduledoc """
  Let's you access Workflows, WorkflowCards, WorkflowCardActivities, WorkflowCardNotes, WorkflowSteps, and WorkflowTasks
  """

  # Activity
  def get(id, card_id: card_id, activity_id: activity_id) do
    id <> "/cards/" <> card_id <> "/activities/" <> activity_id
    |> get([])
  end

  # Note
  def get(id, card_id: card_id, note_id: note_id) do
    id <> "/cards/" <> card_id <> "/notes/" <> note_id
    |> get([])
  end

  # Task
  def get(id, card_id: card_id, task_id: task_id) do
    id <> "/cards/" <> card_id <> "/tasks/" <> task_id
    |> get([])
  end

  # Card
  def get(id, card_id: card_id) do
    id <> "/cards/" <> card_id
    |> get([])
  end

  # Step
  def get(id, step_id: step_id) do
    id <> "/steps/" <> step_id
    |> get([])
  end

  def cards(id) do
    id <> "/cards"
    |> get([])
  end

  def activities(id, card_id: card_id) do
    id <> "/cards/" <> card_id <> "/activities"
    |> get([])
  end

  def notes(id, card_id: card_id) do
    id <> "/cards/" <> card_id <> "/notes"
    |> get([])
  end

  def steps(id) do
    id <> "/steps"
    |> get([])
  end

  def tasks(id, card_id: card_id) do
    id <> "/cards/" <> card_id <> "/tasks"
    |> get([])
  end

  use PcoApi.Actions

  endpoint "https://api.planningcenteronline.com/people/v2/workflows/"
end
