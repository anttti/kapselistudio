defmodule KapselistudioWeb.FeedController do
  use KapselistudioWeb, :controller
  alias Calendar.DateTime
  alias Kapselistudio.Media
  import Phoenix.HTML

  defp escape(str) do
    str |> html_escape() |> safe_to_string()
  end

  defp format_xml_episode(episode, podcast) do
    %{
      number: episode.number,
      title: escape(episode.title),
      subtitle:
        escape(
          if(String.length(episode.description) > 255,
            do: "#{String.slice(episode.description, 0..254)}…",
            else: episode.description
          )
        ),
      # Not escaped, as it's rendered inside a <![CDATA
      shownotes: episode.shownotes,
      link: "https://webbidevaus.fi/" <> to_string(episode.number),
      publishDate: episode.published_at |> DateTime.Format.httpdate(),
      author: "#{podcast.owner_email} (#{podcast.owner_name})",
      contentUrl: episode.url,
      fileSize: episode.filesize,
      duration: episode.duration,
      summary: escape(episode.description),
      explicit: if(episode.explicit, do: "yes", else: "no"),
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
      title: escape(podcast.name),
      url: podcast.url,
      # TODO: Make dynamic
      feedPath: "https://kapselistudio.net/1/feed.xml",
      imagePath: "https://kapselistudio.net/images/webbidevaus-logo.jpg",
      language: "fi",
      # TODO: Get current year
      currentYear: "2022",
      lastEpisodeDate: publishDate,
      description: escape(podcast.description),
      explicit: if(podcast.explicit, do: "true", else: "false"),
      type: "episodic",
      keywords: podcast.keywords,
      owner_name: escape(podcast.owner_name),
      owner_email: escape(podcast.owner_email),
      main_category: podcast.main_category,
      sub_category1: if(podcast.sub_category_1, do: podcast.sub_category_1, else: ""),
      sub_category2: if(podcast.sub_category_2, do: podcast.sub_category_2, else: ""),
      sub_category3: if(podcast.sub_category_3, do: podcast.sub_category_3, else: ""),
      episodes: episodes
    }

    conn
    |> put_resp_content_type("text/xml")
    |> render("index.xml", feed)
  end
end
