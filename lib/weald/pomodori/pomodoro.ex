defmodule Weald.Pomodori.Pomodoro do
  use Ecto.Schema
  import Ecto.Changeset

  schema "pomodoro" do
    field :remaining, :time
    field :done_at, :utc_datetime
    field :finished_at, :utc_datetime

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(pomodoro, attrs) do
    pomodoro
    |> cast(attrs, [:remaining, :done_at, :finished_at])
    |> validate_required([:remaining, :done_at, :finished_at])
  end
end
