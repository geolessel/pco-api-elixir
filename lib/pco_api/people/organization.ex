defmodule PcoApi.People.Organization do
  @moduledoc false

  use PcoApi.Actions, only: [:get]

  def get, do: get("")

  # These are not linked_associations because they
  # are not provided a PcoApi.Record with a link url
  def apps, do: get("apps")
  def campuses, do: get("campuses")
  def carriers, do: get("carriers")
  def emails, do: get("emails")
  def field_definitions, do: get("field_definitions")
  def households, do: get("households")
  def inactive_reasons, do: get("inactive_reasons")
  def lists, do: get("lists")
  def marital_statuses, do: get("marital_statuses")
  def message_groups, do: get("message_groups")
  def messages, do: get("messages")
  def name_prefixes, do: get("name_prefixes")
  def name_suffixes, do: get("name_suffixes")
  def people, do: get("people")
  def people_imports, do: get("people_imports")
  def reports, do: get("reports")
  def school_options, do: get("school_options")
  def social_profiles, do: get("social_profiles")
  def stats, do: get("stats")
  def tabs, do: get("tabs")
  def workflows, do: get("workflows")
end
