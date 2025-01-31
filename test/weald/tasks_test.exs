defmodule Weald.TasksTest do
  use Weald.DataCase

  alias Weald.Tasks

  describe "tasks" do
    alias Weald.Tasks.Task

    import Weald.TasksFixtures

    @invalid_attrs %{status: nil, description: nil, started_at: nil, created_at: nil, finished_at: nil}

    test "list_tasks/0 returns all tasks" do
      task = task_fixture()
      assert Tasks.list_tasks() == [task]
    end

    test "get_task!/1 returns the task with given id" do
      task = task_fixture()
      assert Tasks.get_task!(task.id) == task
    end

    test "create_task/1 with valid data creates a task" do
      valid_attrs = %{status: :todo, description: "some description", started_at: ~U[2025-01-23 04:11:00Z], created_at: ~U[2025-01-23 04:11:00Z], finished_at: ~U[2025-01-23 04:11:00Z]}

      assert {:ok, %Task{} = task} = Tasks.create_task(valid_attrs)
      assert task.status == :todo
      assert task.description == "some description"
      assert task.started_at == ~U[2025-01-23 04:11:00Z]
      assert task.created_at == ~U[2025-01-23 04:11:00Z]
      assert task.finished_at == ~U[2025-01-23 04:11:00Z]
    end

    test "create_task/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Tasks.create_task(@invalid_attrs)
    end

    test "update_task/2 with valid data updates the task" do
      task = task_fixture()
      update_attrs = %{status: :started, description: "some updated description", started_at: ~U[2025-01-24 04:11:00Z], created_at: ~U[2025-01-24 04:11:00Z], finished_at: ~U[2025-01-24 04:11:00Z]}

      assert {:ok, %Task{} = task} = Tasks.update_task(task, update_attrs)
      assert task.status == :started
      assert task.description == "some updated description"
      assert task.started_at == ~U[2025-01-24 04:11:00Z]
      assert task.created_at == ~U[2025-01-24 04:11:00Z]
      assert task.finished_at == ~U[2025-01-24 04:11:00Z]
    end

    test "update_task/2 with invalid data returns error changeset" do
      task = task_fixture()
      assert {:error, %Ecto.Changeset{}} = Tasks.update_task(task, @invalid_attrs)
      assert task == Tasks.get_task!(task.id)
    end

    test "delete_task/1 deletes the task" do
      task = task_fixture()
      assert {:ok, %Task{}} = Tasks.delete_task(task)
      assert_raise Ecto.NoResultsError, fn -> Tasks.get_task!(task.id) end
    end

    test "change_task/1 returns a task changeset" do
      task = task_fixture()
      assert %Ecto.Changeset{} = Tasks.change_task(task)
    end
  end

  describe "tasks" do
    alias Weald.Tasks.Task

    import Weald.TasksFixtures

    @invalid_attrs %{description: nil, started_at: nil, title: nil, completed: nil, created_at: nil, finished_at: nil}

    test "list_tasks/0 returns all tasks" do
      task = task_fixture()
      assert Tasks.list_tasks() == [task]
    end

    test "get_task!/1 returns the task with given id" do
      task = task_fixture()
      assert Tasks.get_task!(task.id) == task
    end

    test "create_task/1 with valid data creates a task" do
      valid_attrs = %{description: "some description", started_at: ~U[2025-01-29 23:13:00Z], title: "some title", completed: :new, created_at: ~U[2025-01-29 23:13:00Z], finished_at: ~U[2025-01-29 23:13:00Z]}

      assert {:ok, %Task{} = task} = Tasks.create_task(valid_attrs)
      assert task.description == "some description"
      assert task.started_at == ~U[2025-01-29 23:13:00Z]
      assert task.title == "some title"
      assert task.completed == :new
      assert task.created_at == ~U[2025-01-29 23:13:00Z]
      assert task.finished_at == ~U[2025-01-29 23:13:00Z]
    end

    test "create_task/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Tasks.create_task(@invalid_attrs)
    end

    test "update_task/2 with valid data updates the task" do
      task = task_fixture()
      update_attrs = %{description: "some updated description", started_at: ~U[2025-01-30 23:13:00Z], title: "some updated title", completed: :started, created_at: ~U[2025-01-30 23:13:00Z], finished_at: ~U[2025-01-30 23:13:00Z]}

      assert {:ok, %Task{} = task} = Tasks.update_task(task, update_attrs)
      assert task.description == "some updated description"
      assert task.started_at == ~U[2025-01-30 23:13:00Z]
      assert task.title == "some updated title"
      assert task.completed == :started
      assert task.created_at == ~U[2025-01-30 23:13:00Z]
      assert task.finished_at == ~U[2025-01-30 23:13:00Z]
    end

    test "update_task/2 with invalid data returns error changeset" do
      task = task_fixture()
      assert {:error, %Ecto.Changeset{}} = Tasks.update_task(task, @invalid_attrs)
      assert task == Tasks.get_task!(task.id)
    end

    test "delete_task/1 deletes the task" do
      task = task_fixture()
      assert {:ok, %Task{}} = Tasks.delete_task(task)
      assert_raise Ecto.NoResultsError, fn -> Tasks.get_task!(task.id) end
    end

    test "change_task/1 returns a task changeset" do
      task = task_fixture()
      assert %Ecto.Changeset{} = Tasks.change_task(task)
    end
  end
end
