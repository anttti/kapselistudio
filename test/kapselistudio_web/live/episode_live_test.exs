defmodule KapselistudioWeb.EpisodeLiveTest do
  use KapselistudioWeb.ConnCase

  import Phoenix.LiveViewTest
  import Kapselistudio.MediaFixtures

  @create_attrs %{
    duration: 42,
    number: 42,
    shownotes: "some shownotes",
    title: "some title",
    url: "some url"
  }
  @update_attrs %{
    duration: 43,
    number: 43,
    shownotes: "some updated shownotes",
    title: "some updated title",
    url: "some updated url"
  }
  @invalid_attrs %{duration: nil, number: nil, shownotes: nil, title: nil, url: nil}

  defp create_episode(_) do
    episode = episode_fixture()
    %{episode: episode}
  end

  describe "Index" do
    setup [:create_episode]

    test "lists all episodes", %{conn: conn, episode: episode} do
      {:ok, _index_live, html} = live(conn, Routes.episode_index_path(conn, :index))

      assert html =~ "Listing Episodes"
      assert html =~ episode.shownotes
    end

    test "saves new episode", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, Routes.episode_index_path(conn, :index))

      assert index_live |> element("a", "New Episode") |> render_click() =~
               "New Episode"

      assert_patch(index_live, Routes.episode_index_path(conn, :new))

      assert index_live
             |> form("#episode-form", episode: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#episode-form", episode: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.episode_index_path(conn, :index))

      assert html =~ "Episode created successfully"
      assert html =~ "some shownotes"
    end

    test "updates episode in listing", %{conn: conn, episode: episode} do
      {:ok, index_live, _html} = live(conn, Routes.episode_index_path(conn, :index))

      assert index_live |> element("#episode-#{episode.id} a", "Edit") |> render_click() =~
               "Edit Episode"

      assert_patch(index_live, Routes.episode_index_path(conn, :edit, episode))

      assert index_live
             |> form("#episode-form", episode: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#episode-form", episode: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.episode_index_path(conn, :index))

      assert html =~ "Episode updated successfully"
      assert html =~ "some updated shownotes"
    end

    test "deletes episode in listing", %{conn: conn, episode: episode} do
      {:ok, index_live, _html} = live(conn, Routes.episode_index_path(conn, :index))

      assert index_live |> element("#episode-#{episode.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#episode-#{episode.id}")
    end
  end

  describe "Show" do
    setup [:create_episode]

    test "displays episode", %{conn: conn, episode: episode} do
      {:ok, _show_live, html} = live(conn, Routes.episode_show_path(conn, :show, episode))

      assert html =~ "Show Episode"
      assert html =~ episode.shownotes
    end

    test "updates episode within modal", %{conn: conn, episode: episode} do
      {:ok, show_live, _html} = live(conn, Routes.episode_show_path(conn, :show, episode))

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Episode"

      assert_patch(show_live, Routes.episode_show_path(conn, :edit, episode))

      assert show_live
             |> form("#episode-form", episode: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#episode-form", episode: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.episode_show_path(conn, :show, episode))

      assert html =~ "Episode updated successfully"
      assert html =~ "some updated shownotes"
    end
  end
end
