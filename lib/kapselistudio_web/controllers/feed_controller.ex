defmodule KapselistudioWeb.FeedController do
  use KapselistudioWeb, :controller
  alias Calendar.DateTime
  alias Kapselistudio.Media

  def format_xml_episode(episode, podcast) do
    %{
      number: episode.number,
      title: episode.title,
      shownotes: episode.shownotes,
      link: "https://webbidevaus.fi/" <> to_string(episode.number),
      publishDate: episode.published_at |> DateTime.Format.httpdate(),
      author: if(episode.author, do: episode.author, else: podcast.author),
      contentUrl: episode.url,
      fileSize: "1234",
      duration: episode.duration,
      summary: episode.description,
      explicit: if(episode.explicit, do: "true", else: "false"),
      episodeType: "full",
      image: "https://webbidevaus.fi/artwork.jpg"
    }
  end

  def index(conn, %{"podcast_id" => podcast_id}) do
    # RFC822 date: Wed, 02 Oct 2002 08:00:00 EST
    publishDate = DateTime.now!("Europe/Copenhagen") |> DateTime.Format.httpdate()

    podcast = Media.get_podcast!(podcast_id)

    episodes =
      podcast_id |> Media.get_published_episodes!() |> Enum.map(&format_xml_episode(&1, podcast))

    feed = %{
      title: podcast.name,
      url: podcast.url,
      feedPath: "/feed.xml",
      imagePath: "",
      language: "fi",
      currentYear: "2021",
      author: podcast.author,
      lastEpisodeDate: publishDate,
      description: podcast.description,
      explicit: if(podcast.explicit, do: "true", else: "false"),
      type: "episodic",
      keywords: "react",
      ownerName: podcast.owner_name,
      ownerEmail: podcast.owner_email,
      mainCategory: podcast.main_category,
      subCategory1: if(podcast.sub_category_1, do: podcast.sub_category_1, else: ""),
      subCategory2: if(podcast.sub_category_2, do: podcast.sub_category_2, else: ""),
      subCategory3: if(podcast.sub_category_3, do: podcast.sub_category_3, else: ""),
      episodes: episodes
    }

    conn
    |> put_resp_content_type("text/xml")
    |> render("index.xml", feed)
  end

  defp slugify(%{title: title, number: number}) do
    slugified_title =
      title
      |> String.downcase()
      |> String.replace(~r"\s", "-")
      |> String.replace(~r"ä", "a")
      |> String.replace(~r"ö", "o")
      |> String.replace(~r"[^a-z\-]", "")

    "#{number}-#{slugified_title}"
  end

  defp format_episode(e) do
    %{
      updated_at: e.updated_at,
      type: "full",
      token: "unknown",
      title: e.title,
      status: "published",
      slug: slugify(e),
      season: %{
        href: "",
        number: 1
      },
      scheduled_for: nil,
      published_at: e.published_at,
      number: e.number,
      is_hidden: false,
      image_url: nil,
      image_path: nil,
      id: "#{e.id}",
      href: "",
      guid: "",
      enclosure_url: e.url,
      duration: e.duration,
      description: e.description,
      long_description: Earmark.as_html!(e.shownotes),
      days_since_release: 0,
      audio_file: %{
        url: e.url
      },
      audio_status: "transcoded",
      analytics: nil
    }
  end

  def episodes(conn, %{"podcast_id" => podcast_id}) do
    episodes =
      podcast_id
      |> Media.get_published_episodes!()
      |> Enum.map(&format_episode/1)

    conn
    |> render("episodes.json", %{episodes: episodes})
  end

  def episode(conn, %{"episode_id" => episode_id}) do
    episode = Media.get_episode!(episode_id) |> format_episode()

    conn
    |> render("episode.json", %{episode: episode})
  end
end
