defmodule Weald.Repo.Migrations.CreatePomodoro do
  use Ecto.Migration

  def change do
    create table(:pomodoro) do
      add :remaining, :time
      add :done_at, :utc_datetime
      add :finished_at, :utc_datetime

      timestamps(type: :utc_datetime)
    end
  end
end
