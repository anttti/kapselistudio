defmodule KapselistudioWeb.FeedController do
  use KapselistudioWeb, :controller
  alias Calendar.DateTime
  alias Kapselistudio.Media

  def format_episode(episode) do
    %{
      number: episode.number,
      title: episode.title,
      shownotes: episode.shownotes,
      link: "https://webbidevaus.fi/" <> to_string(episode.number),
      publishDate: episode.published_at |> DateTime.Format.httpdate(),
      author: "Antti",
      contentUrl: episode.url,
      fileSize: "1234",
      duration: "45",
      summary: "Summary",
      explicit: "false",
      episodeType: "full",
      image: "https://webbidevaus.fi/artwork.jpg"
    }
  end

  def index(conn, %{"podcast_id" => podcast_id}) do
    # RFC822 date: Wed, 02 Oct 2002 08:00:00 EST
    publishDate = DateTime.now!("Europe/Copenhagen") |> DateTime.Format.httpdate()

    podcast = Media.get_podcast!(podcast_id)
    episodes = podcast_id |> Media.get_published_episodes!() |> Enum.map(&format_episode/1)

    feed = %{
      title: podcast.name,
      url: "https://webbidevaus.fi",
      feedPath: "/feed.xml",
      imagePath: "",
      language: "fi",
      currentYear: "2021",
      author: "Antti Mattila & Tommi Pääkkö",
      lastEpisodeDate: publishDate,
      description: "Webbidevaus desc",
      explicit: "false",
      type: "episodic",
      keywords: "react",
      ownerName: "Antti Mattila & Tommi Pääkkö",
      ownerEmail: "me@rarelyneeded.com",
      mainCategory: "Tech",
      subCategory1: "",
      subCategory2: "",
      subCategory3: "",
      episodes: episodes
    }

    conn
    |> put_resp_content_type("text/xml")
    |> render("index.xml", feed)
  end
end
