Mix.install([
  {:elixir_xml_to_map, "~> 3.0.0"},
  {:date_time_parser, "~> 1.1.3"}
])

defmodule ParseRSS do
  def parse(file) do
    parsedRss =
      with {:ok, rss} <- File.read(file) do
        XmlToMap.naive_map(rss)
      end

    episodes =
      parsedRss |> Map.get("rss") |> Map.get("#content") |> Map.get("channel") |> Map.get("item")

    inserts =
      for episode <- episodes do
        shownotes =
          "<div>#{episode |> Map.get("content:encoded") |> String.replace("<![CDATA[", "") |> String.replace("]]>", "")}</div>"

        published_at =
          with episode <- Map.get(episode, "pubDate"),
               {:ok, date} <- DateTimeParser.parse_datetime(episode) do
            Calendar.strftime(date, "%c")
          end

        """
          INSERT INTO episodes
            (number, url, duration, title, shownotes, status, published_at, inserted_at, updated_at, podcast_id, description)
          VALUES
            (
              #{Map.get(episode, "itunes:episode")},
              '#{episode |> Map.get("enclosure") |> Map.get("-url")}',
              #{episode |> Map.get("itunes:duration") |> parse_duration()},
              '#{episode |> Map.get("itunes:title") |> String.replace(~r/^\d+: /, "") |> escape_quotes()}',
              '#{escape_quotes(shownotes)}',
              'PUBLISHED',
              '#{published_at}',
              NOW(),
              NOW(),
              1,
              '#{episode |> Map.get("itunes:summary") |> escape_quotes()}'
            );
        """
      end

    File.write("inserts.sql", Enum.join(inserts))
  end

  defp escape_quotes(str) do
    String.replace(str, "'", "''")
  end

  defp parse_duration(duration) do
    parts = String.split(duration, ":")

    [hours, minutes, seconds] =
      for p <- parts do
        {num, _} = Integer.parse(p)
        num
      end

    hours * 3600 + minutes * 60 + seconds
  end
end

[file] = System.argv()
ParseRSS.parse(file)
