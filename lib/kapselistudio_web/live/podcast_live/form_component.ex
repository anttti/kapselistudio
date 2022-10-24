defmodule KapselistudioWeb.PodcastLive.FormComponent do
  use KapselistudioWeb, :live_component

  alias Kapselistudio.Media

  @categories %{
    "Arts" => [
      "Books",
      "Design",
      "Fashion & Beauty",
      "Food",
      "Performing Arts",
      "Visual Arts"
    ],
    "Business" => [
      "Careers",
      "Entrepreneurship",
      "Investing",
      "Management",
      "Marketing",
      "Non-Profit"
    ],
    "Comedy" => [
      "Comedy Interviews",
      "Improv",
      "Stand-Up"
    ],
    "Education" => [
      "Courses",
      "How To",
      "Language Learning",
      "Self-Improvement"
    ],
    "Fiction" => [
      "Comedy Fiction",
      "Drama",
      "Science Fiction"
    ],
    "Government" => [],
    "History" => [],
    "Health & Fitness" => [
      "Alternative Health",
      "Fitness",
      "Medicine",
      "Mental Health",
      "Nutrition",
      "Sexuality"
    ],
    "Kids & Family" => [
      "Education for Kids",
      "Parenting",
      "Pets & Animals",
      "Stories for Kids"
    ],
    "Leisure" => [
      "Animation & Manga",
      "Automotive",
      "Aviation",
      "Crafts",
      "Games",
      "Hobbies",
      "Home & Garden",
      "Video Games"
    ],
    "Music" => [
      "Music Commentary",
      "Music History",
      "Music Interviews"
    ],
    "News" => [
      "Business News",
      "Daily News",
      "Entertainment News",
      "News Commentary",
      "Politics",
      "Sports News",
      "Tech News"
    ],
    "Religion & Spirituality" => [
      "Buddhism",
      "Christianity",
      "Hinduism",
      "Islam",
      "Judaism",
      "Religion",
      "Spirituality "
    ],
    "Science" => [
      "Astronomy",
      "Chemistry",
      "Earth Sciences",
      "Life Sciences",
      "Mathematics",
      "Natural Sciences",
      "Nature",
      "Physics",
      "Social Sciences"
    ],
    "Society & Culture" => [
      "Documentary",
      "Personal Journals",
      "Philosophy",
      "Places & Travel",
      "Relationships"
    ],
    "Sports" => [
      "Baseball",
      "Basketball",
      "Cricket",
      "Fantasy Sports",
      "Football",
      "Golf",
      "Hockey",
      "Rugby",
      "Soccer",
      "Swimming",
      "Tennis",
      "Volleyball",
      "Wilderness",
      "Wrestling"
    ],
    "Technology" => [],
    "True Crime" => [],
    "TV & Film" => [
      "After Shows",
      "Film History",
      "Film Interviews",
      "Film Reviews",
      "TV Reviews"
    ]
  }

  @impl true
  def mount(socket) do
    {:ok,
     socket
     |> assign(:main_categories, Map.keys(@categories))
     |> assign(:sub_categories_1, Map.get(@categories, []))
     |> assign(:sub_categories_2, Map.get(@categories, []))
     |> assign(:sub_categories_3, Map.get(@categories, []))}
  end

  @impl true
  def update(%{podcast: podcast} = assigns, socket) do
    changeset = Media.change_podcast(podcast)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)
     |> assign(:sub_categories_1, Map.get(@categories, podcast.main_category_1, []))
     |> assign(:sub_categories_2, Map.get(@categories, podcast.main_category_2, []))
     |> assign(:sub_categories_3, Map.get(@categories, podcast.main_category_3, []))}
  end

  @impl true
  def handle_event("validate", %{"podcast" => podcast_params}, socket) do
    podcast_params = ensure_authors_is_list(podcast_params)

    changeset =
      socket.assigns.podcast
      |> Media.change_podcast(podcast_params)
      |> Map.put(:action, :validate)

    {:noreply,
     socket
     |> assign(:changeset, changeset)
     |> assign(
       :sub_categories_1,
       Map.get(@categories, Map.get(podcast_params, "main_category_1"), [])
     )
     |> assign(
       :sub_categories_2,
       Map.get(@categories, Map.get(podcast_params, "main_category_2"), [])
     )
     |> assign(
       :sub_categories_3,
       Map.get(@categories, Map.get(podcast_params, "main_category_3"), [])
     )}
  end

  def handle_event("save", %{"podcast" => podcast_params}, socket) do
    save_podcast(socket, socket.assigns.action, podcast_params)
  end

  defp save_podcast(socket, :edit, podcast_params) do
    podcast_params = ensure_authors_is_list(podcast_params)

    case Media.update_podcast(socket.assigns.podcast, podcast_params) do
      {:ok, _podcast} ->
        {:noreply,
         socket
         |> put_flash(:info, "Podcast updated successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_podcast(socket, :new, podcast_params) do
    podcast_params = ensure_authors_is_list(podcast_params)

    case Media.create_podcast(podcast_params) do
      {:ok, _podcast} ->
        {:noreply,
         socket
         |> put_flash(:info, "Podcast created successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end

  defp ensure_authors_is_list(%{"authors" => authors} = params) when is_list(authors) do
    params
  end

  defp ensure_authors_is_list(params) do
    Map.put(params, "authors", [Map.get(params, "authors")])
  end
end
