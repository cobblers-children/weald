defmodule Weald.Pomodori.Pomodoro do
  use Ecto.Schema
  import Ecto.Changeset

  schema "pomodoro" do
    field :remaining, :integer
    field :due_at, :utc_datetime
    field :finished_at, :utc_datetime

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(pomodoro, attrs) do
    pomodoro
    |> cast(attrs, [:remaining, :due_at, :finished_at])
    |> validate_required([:remaining, :due_at, :finished_at])
  end
end
