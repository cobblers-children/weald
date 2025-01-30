defmodule Weald.PomodoriFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Weald.Pomodori` context.
  """

  @doc """
  Generate a pomodoro.
  """
  def pomodoro_fixture(attrs \\ %{}) do
    {:ok, pomodoro} =
      attrs
      |> Enum.into(%{
        done_at: ~U[2025-01-24 07:19:00Z],
        finished_at: ~U[2025-01-24 07:19:00Z],
        remaining: ~T[14:00:00]
      })
      |> Weald.Pomodori.create_pomodoro()

    pomodoro
  end

  @doc """
  Generate a pomodoro.
  """
  def pomodoro_fixture(attrs \\ %{}) do
    {:ok, pomodoro} =
      attrs
      |> Enum.into(%{
        due_at: ~U[2025-01-28 06:35:00Z],
        finished_at: ~U[2025-01-28 06:35:00Z],
        remaining: 42
      })
      |> Weald.Pomodori.create_pomodoro()

    pomodoro
  end

  @doc """
  Generate a pomodoro.
  """
  def pomodoro_fixture(attrs \\ %{}) do
    {:ok, pomodoro} =
      attrs
      |> Enum.into(%{
        due_at: ~U[2025-01-28 23:03:00Z],
        finished_at: ~U[2025-01-28 23:03:00Z],
        remaining: 42,
        running: true,
        stage: :pomodoro
      })
      |> Weald.Pomodori.create_pomodoro()

    pomodoro
  end
end
