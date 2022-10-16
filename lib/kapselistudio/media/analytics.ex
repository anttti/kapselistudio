defmodule Kapselistudio.Media.Analytics do
  # From https://kapselistudio.net/audio-files/Webbidevaus_1.mp3
  # to https://dts.podtrac.com/redirect.mp4/kapselistudio.net/audio-files/Webbidevaus_1.mp3
  def with_analytics(url) do
    String.replace(
      url,
      ~r/^http(s?):\/\//,
      Application.fetch_env!(:kapselistudio, :analytics_prefix)
    )
  end
end
