defmodule Weald.Pomodori.Pomodoro do
  use Ecto.Schema
  import Ecto.Changeset

  schema "pomodoro" do
    field :running, :boolean, default: false
    field :stage, Ecto.Enum, values: [:pomodoro, :break, :done, :cancelled], default: :pomodoro
    field :remaining, :integer, default: 25 * 60
    field :due_at, :utc_datetime
    field :finished_at, :utc_datetime

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(pomodoro, attrs) do
    updated = cast(pomodoro, attrs, [:running, :stage, :remaining, :due_at, :finished_at])

    cond do
      pomodoro.stage in [:done] ->
        validate_required(updated, [:stage, :finished_at])
      pomodoro.running ->
        validate_required(updated, [:stage, :remaining, :due_at])
      true ->
        validate_required(updated, [:stage, :remaining])
    end
  end
end
