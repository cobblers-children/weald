defmodule Weald.PomodoriTest do
  use Weald.DataCase

  alias Weald.Pomodori

  describe "pomodoro" do
    alias Weald.Pomodori.Pomodoro

    import Weald.PomodoriFixtures

    @invalid_attrs %{remaining: nil, done_at: nil, finished_at: nil}

    test "list_pomodoro/0 returns all pomodoro" do
      pomodoro = pomodoro_fixture()
      assert Pomodori.list_pomodoro() == [pomodoro]
    end

    test "get_pomodoro!/1 returns the pomodoro with given id" do
      pomodoro = pomodoro_fixture()
      assert Pomodori.get_pomodoro!(pomodoro.id) == pomodoro
    end

    test "create_pomodoro/1 with valid data creates a pomodoro" do
      valid_attrs = %{remaining: ~T[14:00:00], done_at: ~U[2025-01-24 07:19:00Z], finished_at: ~U[2025-01-24 07:19:00Z]}

      assert {:ok, %Pomodoro{} = pomodoro} = Pomodori.create_pomodoro(valid_attrs)
      assert pomodoro.remaining == ~T[14:00:00]
      assert pomodoro.done_at == ~U[2025-01-24 07:19:00Z]
      assert pomodoro.finished_at == ~U[2025-01-24 07:19:00Z]
    end

    test "create_pomodoro/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Pomodori.create_pomodoro(@invalid_attrs)
    end

    test "update_pomodoro/2 with valid data updates the pomodoro" do
      pomodoro = pomodoro_fixture()
      update_attrs = %{remaining: ~T[15:01:01], done_at: ~U[2025-01-25 07:19:00Z], finished_at: ~U[2025-01-25 07:19:00Z]}

      assert {:ok, %Pomodoro{} = pomodoro} = Pomodori.update_pomodoro(pomodoro, update_attrs)
      assert pomodoro.remaining == ~T[15:01:01]
      assert pomodoro.done_at == ~U[2025-01-25 07:19:00Z]
      assert pomodoro.finished_at == ~U[2025-01-25 07:19:00Z]
    end

    test "update_pomodoro/2 with invalid data returns error changeset" do
      pomodoro = pomodoro_fixture()
      assert {:error, %Ecto.Changeset{}} = Pomodori.update_pomodoro(pomodoro, @invalid_attrs)
      assert pomodoro == Pomodori.get_pomodoro!(pomodoro.id)
    end

    test "delete_pomodoro/1 deletes the pomodoro" do
      pomodoro = pomodoro_fixture()
      assert {:ok, %Pomodoro{}} = Pomodori.delete_pomodoro(pomodoro)
      assert_raise Ecto.NoResultsError, fn -> Pomodori.get_pomodoro!(pomodoro.id) end
    end

    test "change_pomodoro/1 returns a pomodoro changeset" do
      pomodoro = pomodoro_fixture()
      assert %Ecto.Changeset{} = Pomodori.change_pomodoro(pomodoro)
    end
  end
end
