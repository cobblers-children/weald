defmodule Weald.TasksFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Weald.Tasks` context.
  """

  @doc """
  Generate a task.
  """
  def task_fixture(attrs \\ %{}) do
    {:ok, task} =
      attrs
      |> Enum.into(%{
        created_at: ~U[2025-01-23 04:11:00Z],
        description: "some description",
        finished_at: ~U[2025-01-23 04:11:00Z],
        started_at: ~U[2025-01-23 04:11:00Z],
        status: :todo
      })
      |> Weald.Tasks.create_task()

    task
  end
end
