defmodule Weald.Tasks.Task do
  use Ecto.Schema
  import Ecto.Changeset

  schema "tasks" do
    field :status, Ecto.Enum, values: [:todo, :started, :done], default: :todo
    field :description, :string
    field :started_at, :utc_datetime
    field :finished_at, :utc_datetime

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(task, attrs) do
    task
    |> cast(attrs, [:description, :status])
    |> validate_required([:description, :status])
  end
end
