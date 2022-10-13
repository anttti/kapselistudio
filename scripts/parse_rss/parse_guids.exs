Mix.install([
  {:elixir_xml_to_map, "~> 3.0.0"}
])

defmodule ParseGUIDs do
  def parse(file) do
    parsedRss =
      with {:ok, rss} <- File.read(file) do
        XmlToMap.naive_map(rss)
      end

    episodes =
      parsedRss |> Map.get("rss") |> Map.get("#content") |> Map.get("channel") |> Map.get("item")

    updates =
      for episode <- episodes do
        """
          UPDATE episodes SET guid = '#{Map.get(episode, "guid") |> Map.get("#content")}'
          WHERE number = #{Map.get(episode, "itunes:episode")};
        """
      end

    File.write("guids.sql", Enum.join(updates))
  end
end

[file] = System.argv()
ParseGUIDs.parse(file)
