defmodule PcoApi.WorkflowTest do
  use ExUnit.Case
  doctest PcoApi.People.Workflow
  alias PcoApi.People.Workflow

  test "can get a list of workflows" do
    assert Workflow.get |> List.first |> Map.get("type") == "Workflow"
  end

  test "can get a single workflow" do
    id = Workflow.get |> List.first |> Map.get("id")
    result = Workflow.get(id)
    assert result["type"] == "Workflow"
  end

  test "can get a list of workflow cards" do
    id = Workflow.get |> List.first |> Map.get("id")
    result = Workflow.cards(id)
    assert result |> List.first |> Map.get("type") == "WorkflowCard"
  end

  test "can get a single workflow card" do
    id = Workflow.get |> List.first |> Map.get("id")
    card_id = Workflow.cards(id) |> List.first |> Map.get("id")
    result = Workflow.get(id, card_id: card_id)
    assert result["type"] == "WorkflowCard"
  end

  test "can get a list of workflow steps" do
    id = Workflow.get |> List.first |> Map.get("id")
    result = Workflow.steps(id)
    assert result |> List.first |> Map.get("type") == "WorkflowStep"
  end

  test "can get a single workflow step" do
    id = Workflow.get |> List.first |> Map.get("id")
    step_id = Workflow.steps(id) |> List.first |> Map.get("id")
    result = Workflow.get(id, step_id: step_id)
    assert result["type"] == "WorkflowStep"
  end

  test "can get a list of workflow card activities" do
    id = Workflow.get |> List.first |> Map.get("id")
    card_id = Workflow.cards(id) |> List.first |> Map.get("id")
    result = Workflow.activities(id, card_id: card_id)
    assert result |> List.first |> Map.get("type") == "WorkflowCardActivity"
  end

  test "can get a single workflow activity" do
    id = Workflow.get |> List.first |> Map.get("id")
    card_id = Workflow.cards(id) |> List.first |> Map.get("id")
    activity_id = Workflow.activities(id, card_id: card_id) |> List.first |> Map.get("id")
    result = Workflow.get(id, card_id: card_id, activity_id: activity_id)
    assert result["type"] == "WorkflowCardActivity"
  end

  test "can get a list of workflow card notes" do
    id = Workflow.get |> List.first |> Map.get("id")
    card_id = Workflow.cards(id) |> List.first |> Map.get("id")
    result = Workflow.notes(id, card_id: card_id)
    assert result |> List.first |> Map.get("type") == "WorkflowCardNote"
  end

  test "can get a single workflow note" do
    id = Workflow.get |> List.first |> Map.get("id")
    card_id = Workflow.cards(id) |> List.first |> Map.get("id")
    note_id = Workflow.notes(id, card_id: card_id) |> List.first |> Map.get("id")
    result = Workflow.get(id, card_id: card_id, note_id: note_id)
    assert result["type"] == "WorkflowCardNote"
  end

  test "can get a list of workflow card tasks" do
    id = Workflow.get |> List.first |> Map.get("id")
    card_id = Workflow.cards(id) |> List.first |> Map.get("id")
    result = Workflow.tasks(id, card_id: card_id)
    assert result |> List.first |> Map.get("type") == "WorkflowTask"
  end

  test "can get a single workflow task" do
    id = Workflow.get |> List.first |> Map.get("id")
    card_id = Workflow.cards(id) |> List.first |> Map.get("id")
    task_id = Workflow.tasks(id, card_id: card_id) |> List.first |> Map.get("id")
    result = Workflow.get(id, card_id: card_id, task_id: task_id)
    assert result["type"] == "WorkflowTask"
  end

end
