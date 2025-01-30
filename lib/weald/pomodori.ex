defmodule Weald.Pomodori do
  @moduledoc """
  The Pomodori context.
  """

  import Ecto.Query, warn: false
  alias Weald.Repo

  alias Weald.Pomodori.Pomodoro

  @doc """
  Returns the list of pomodoro.

  ## Examples

      iex> list_pomodoro()
      [%Pomodoro{}, ...]

  """
  def list_pomodoro do
    Repo.all(Pomodoro)
  end

  def find_running do
    query = from p in Pomodoro, where: (p.running == true) and (p.stage == :pomodoro or p.stage == :break)

    Repo.all(query)
  end

  @doc """
  Gets a single pomodoro.

  Raises `Ecto.NoResultsError` if the Pomodoro does not exist.

  ## Examples

      iex> get_pomodoro!(123)
      %Pomodoro{}

      iex> get_pomodoro!(456)
      ** (Ecto.NoResultsError)

  """
  def get_pomodoro!(id), do: Repo.get!(Pomodoro, id)

  @doc """
  Creates a pomodoro.

  ## Examples

      iex> create_pomodoro(%{field: value})
      {:ok, %Pomodoro{}}

      iex> create_pomodoro(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_pomodoro(attrs \\ %{}) do
    %Pomodoro{}
    |> Pomodoro.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a pomodoro.

  ## Examples

      iex> update_pomodoro(pomodoro, %{field: new_value})
      {:ok, %Pomodoro{}}

      iex> update_pomodoro(pomodoro, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_pomodoro(%Pomodoro{} = pomodoro, attrs) do
    pomodoro
    |> Pomodoro.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a pomodoro.

  ## Examples

      iex> delete_pomodoro(pomodoro)
      {:ok, %Pomodoro{}}

      iex> delete_pomodoro(pomodoro)
      {:error, %Ecto.Changeset{}}

  """
  def delete_pomodoro(%Pomodoro{} = pomodoro) do
    Repo.delete(pomodoro)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking pomodoro changes.

  ## Examples

      iex> change_pomodoro(pomodoro)
      %Ecto.Changeset{data: %Pomodoro{}}

  """
  def change_pomodoro(%Pomodoro{} = pomodoro, attrs \\ %{}) do
    Pomodoro.changeset(pomodoro, attrs)
  end
end
