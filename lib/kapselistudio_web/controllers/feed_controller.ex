defmodule KapselistudioWeb.FeedController do
  use KapselistudioWeb, :controller
  alias Calendar.DateTime
  alias Kapselistudio.Media

  defp format_xml_episode(episode, podcast) do
    %{
      number: episode.number,
      title: episode.title,
      shownotes: episode.shownotes,
      link: "https://webbidevaus.fi/" <> to_string(episode.number),
      publishDate: episode.published_at |> DateTime.Format.httpdate(),
      author: if(episode.author, do: episode.author, else: podcast.author),
      contentUrl: episode.url,
      fileSize: episode.filesize,
      duration: episode.duration,
      summary: episode.description,
      explicit: if(episode.explicit, do: "true", else: "false"),
      episodeType: "full",
      image: "https://kapselistudio.net/images/webbidevaus-logo.jpg",
      guid: episode.guid
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
      # TODO: Make dynamic
      feedPath: "https://kapselistudio.net/1/feed.xml",
      imagePath: "https://kapselistudio.net/images/webbidevaus-logo.jpg",
      language: "fi",
      # TODO: Get current year
      currentYear: "2022",
      author: podcast.author,
      lastEpisodeDate: publishDate,
      description: podcast.description,
      explicit: if(podcast.explicit, do: "true", else: "false"),
      type: "episodic",
      keywords: podcast.keywords,
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
end
