defmodule PcoApi.People.Workflow.Card do
  @moduledoc """
  Let's you access Workflows, WorkflowCards, WorkflowCardActivities, WorkflowCardNotes, WorkflowSteps, and WorkflowTasks
  """

  def get(id, params) do
    url_str = id <> "/cards"
    get(url_str, params)
  end

  def get(id, card_id: card_id = params) do
    IO.puts "what"
    url_str = id <> "/cards/" <> card_id
    get(url_str, Map.to_list(params))
  end

  use PcoApi.Actions

  endpoint "https://api.planningcenteronline.com/people/v2/workflows/"
end
