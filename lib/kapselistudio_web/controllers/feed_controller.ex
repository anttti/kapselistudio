defmodule KapselistudioWeb.FeedController do
  use KapselistudioWeb, :controller
  alias Calendar.DateTime

  def index(conn, _params) do
    # RFC822 date: Wed, 02 Oct 2002 08:00:00 EST
    publishDate = DateTime.now!("Europe/Copenhagen") |> DateTime.Format.httpdate()

    episode = %{
      number: "1",
      title: "Eka epi",
      shownotes: "Shownotet",
      link: "https://webbidevaus.fi/1",
      publishDate: publishDate,
      author: "Antti",
      contentUrl: "https://webbidevaus.fi/1.mp3",
      fileSize: "1234",
      duration: "45",
      summary: "Summary",
      explicit: "false",
      episodeType: "full",
      image: "https://webbidevaus.fi/artwork.jpg"
    }

    feed = %{
      title: "Webbidevaus.fi",
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
      episodes: [episode]
    }

    conn
    |> put_resp_content_type("text/xml")
    |> render("index.xml", feed)
  end
end
