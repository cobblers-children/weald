defmodule WealdWeb.PomodoroLiveTest do
  use WealdWeb.ConnCase

  import Phoenix.LiveViewTest
  import Weald.PomodoriFixtures

  @create_attrs %{running: true, stage: :pomodoro, remaining: 42, due_at: "2025-01-28T23:03:00Z", finished_at: "2025-01-28T23:03:00Z"}
  @update_attrs %{running: false, stage: :break, remaining: 43, due_at: "2025-01-29T23:03:00Z", finished_at: "2025-01-29T23:03:00Z"}
  @invalid_attrs %{running: false, stage: nil, remaining: nil, due_at: nil, finished_at: nil}

  defp create_pomodoro(_) do
    pomodoro = pomodoro_fixture()
    %{pomodoro: pomodoro}
  end

  describe "Index" do
    setup [:create_pomodoro]

    test "lists all pomodoro", %{conn: conn} do
      {:ok, _index_live, html} = live(conn, ~p"/pomodoro")

      assert html =~ "Listing Pomodoro"
    end

    test "saves new pomodoro", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/pomodoro")

      assert index_live |> element("a", "New Pomodoro") |> render_click() =~
               "New Pomodoro"

      assert_patch(index_live, ~p"/pomodoro/new")

      assert index_live
             |> form("#pomodoro-form", pomodoro: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#pomodoro-form", pomodoro: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/pomodoro")

      html = render(index_live)
      assert html =~ "Pomodoro created successfully"
    end

    test "updates pomodoro in listing", %{conn: conn, pomodoro: pomodoro} do
      {:ok, index_live, _html} = live(conn, ~p"/pomodoro")

      assert index_live |> element("#pomodoro-#{pomodoro.id} a", "Edit") |> render_click() =~
               "Edit Pomodoro"

      assert_patch(index_live, ~p"/pomodoro/#{pomodoro}/edit")

      assert index_live
             |> form("#pomodoro-form", pomodoro: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#pomodoro-form", pomodoro: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/pomodoro")

      html = render(index_live)
      assert html =~ "Pomodoro updated successfully"
    end

    test "deletes pomodoro in listing", %{conn: conn, pomodoro: pomodoro} do
      {:ok, index_live, _html} = live(conn, ~p"/pomodoro")

      assert index_live |> element("#pomodoro-#{pomodoro.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#pomodoro-#{pomodoro.id}")
    end
  end

  describe "Show" do
    setup [:create_pomodoro]

    test "displays pomodoro", %{conn: conn, pomodoro: pomodoro} do
      {:ok, _show_live, html} = live(conn, ~p"/pomodoro/#{pomodoro}")

      assert html =~ "Show Pomodoro"
    end

    test "updates pomodoro within modal", %{conn: conn, pomodoro: pomodoro} do
      {:ok, show_live, _html} = live(conn, ~p"/pomodoro/#{pomodoro}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Pomodoro"

      assert_patch(show_live, ~p"/pomodoro/#{pomodoro}/show/edit")

      assert show_live
             |> form("#pomodoro-form", pomodoro: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#pomodoro-form", pomodoro: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/pomodoro/#{pomodoro}")

      html = render(show_live)
      assert html =~ "Pomodoro updated successfully"
    end
  end
end
