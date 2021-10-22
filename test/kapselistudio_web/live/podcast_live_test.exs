defmodule KapselistudioWeb.PodcastLiveTest do
  use KapselistudioWeb.ConnCase

  import Phoenix.LiveViewTest
  import Kapselistudio.MediaFixtures

  @create_attrs %{name: "some name"}
  @update_attrs %{name: "some updated name"}
  @invalid_attrs %{name: nil}

  defp create_podcast(_) do
    podcast = podcast_fixture()
    %{podcast: podcast}
  end

  describe "Index" do
    setup [:create_podcast]

    test "lists all podcasts", %{conn: conn, podcast: podcast} do
      {:ok, _index_live, html} = live(conn, Routes.podcast_index_path(conn, :index))

      assert html =~ "Listing Podcasts"
      assert html =~ podcast.name
    end

    test "saves new podcast", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, Routes.podcast_index_path(conn, :index))

      assert index_live |> element("a", "New Podcast") |> render_click() =~
               "New Podcast"

      assert_patch(index_live, Routes.podcast_index_path(conn, :new))

      assert index_live
             |> form("#podcast-form", podcast: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#podcast-form", podcast: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.podcast_index_path(conn, :index))

      assert html =~ "Podcast created successfully"
      assert html =~ "some name"
    end

    test "updates podcast in listing", %{conn: conn, podcast: podcast} do
      {:ok, index_live, _html} = live(conn, Routes.podcast_index_path(conn, :index))

      assert index_live |> element("#podcast-#{podcast.id} a", "Edit") |> render_click() =~
               "Edit Podcast"

      assert_patch(index_live, Routes.podcast_index_path(conn, :edit, podcast))

      assert index_live
             |> form("#podcast-form", podcast: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#podcast-form", podcast: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.podcast_index_path(conn, :index))

      assert html =~ "Podcast updated successfully"
      assert html =~ "some updated name"
    end

    test "deletes podcast in listing", %{conn: conn, podcast: podcast} do
      {:ok, index_live, _html} = live(conn, Routes.podcast_index_path(conn, :index))

      assert index_live |> element("#podcast-#{podcast.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#podcast-#{podcast.id}")
    end
  end

  describe "Show" do
    setup [:create_podcast]

    test "displays podcast", %{conn: conn, podcast: podcast} do
      {:ok, _show_live, html} = live(conn, Routes.podcast_show_path(conn, :show, podcast))

      assert html =~ "Show Podcast"
      assert html =~ podcast.name
    end

    test "updates podcast within modal", %{conn: conn, podcast: podcast} do
      {:ok, show_live, _html} = live(conn, Routes.podcast_show_path(conn, :show, podcast))

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Podcast"

      assert_patch(show_live, Routes.podcast_show_path(conn, :edit, podcast))

      assert show_live
             |> form("#podcast-form", podcast: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#podcast-form", podcast: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.podcast_show_path(conn, :show, podcast))

      assert html =~ "Podcast updated successfully"
      assert html =~ "some updated name"
    end
  end
end
