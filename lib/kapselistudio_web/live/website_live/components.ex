defmodule KapselistudioWeb.WebsiteLive.Components do
  import Phoenix.LiveView.Helpers

  def page(assigns) do
    ~H"""
    <div class="body">
      <div class="sidebar bg-body-bg">
        <div class="p-4 md:p-8 flex flex-col text-secondary items-center md:items-start">
          <%= live_redirect(
            to:
              KapselistudioWeb.SubdomainRouter.Helpers.website_show_podcast_path(
                KapselistudioWeb.Endpoint,
                :show_podcast
              )
          ) do %>
            <svg class="w-32 h-32 md:w-64 md:h-64 mb-4 md:mb-8 rounded-xl" viewBox="0 0 3000 3000">
              <rect width="3000" height="3000" fill="url(#paint0_linear_4_4)" />
              <path
                d="M901.5 1753.6L442.5 1587.1V1426.9L901.5 1260.4V1413.4L500.1 1551.1V1462.9L901.5 1600.6V1753.6ZM1018.61 1822V1354C1018.61 1290.4 1037.51 1239.7 1075.31 1201.9C1113.71 1164.1 1168.01 1145.2 1238.21 1145.2C1259.81 1145.2 1281.41 1147.3 1303.01 1151.5C1325.21 1155.1 1343.81 1161.1 1358.81 1169.5L1310.21 1310.8C1303.61 1307.8 1296.41 1305.1 1288.61 1302.7C1280.81 1300.3 1272.71 1299.1 1264.31 1299.1C1249.91 1299.1 1238.21 1303.6 1229.21 1312.6C1220.21 1321.6 1215.71 1336 1215.71 1355.8V1379.2L1222.01 1462.9V1822H1018.61ZM951.105 1505.2V1356.7H1322.81V1505.2H951.105ZM1402.01 1822V1329.7H1605.41V1822H1402.01ZM1503.71 1290.1C1466.51 1290.1 1436.81 1280.2 1414.61 1260.4C1392.41 1240.6 1381.31 1216 1381.31 1186.6C1381.31 1157.2 1392.41 1132.6 1414.61 1112.8C1436.81 1093 1466.51 1083.1 1503.71 1083.1C1540.91 1083.1 1570.61 1092.4 1592.81 1111C1615.01 1129.6 1626.11 1153.6 1626.11 1183C1626.11 1214.2 1615.01 1240 1592.81 1260.4C1570.61 1280.2 1540.91 1290.1 1503.71 1290.1ZM1614.71 1912L1911.71 1064.2H2091.71L1794.71 1912H1614.71ZM2096.6 1753.6V1600.6L2498 1462.9V1551.1L2096.6 1413.4V1260.4L2555.6 1426.9V1587.1L2096.6 1753.6Z"
                fill="white"
              />
              <defs>
                <linearGradient
                  id="paint0_linear_4_4"
                  x1="1500"
                  y1="0"
                  x2="1500"
                  y2="3000"
                  gradientUnits="userSpaceOnUse"
                >
                  <stop stop-color="#B2004E" />
                  <stop offset="1" stop-color="#D63169" />
                </linearGradient>
              </defs>
            </svg>
          <% end %>
          <h1 class="font-bold text-2xl mb-2 md:mb-4"><%= @name %></h1>
          <p class="mb-2 md:mb-4"><%= @description %></p>
          <p><%= @author %></p>
        </div>
      </div>
      <div class="content">
        <%= render_slot(@inner_block) %>
      </div>
    </div>
    """
  end

  def play_button(assigns) do
    ~H"""
    <button
      class="text-sm py-2 play-button flex gap-4 items-center"
      data-url={@url}
      data-title={@title}
      data-number={@number}
    >
      <svg viewBox="0 0 39 46" class="w-3">
        <path
          fill="currentColor"
          d="M-2.5034e-06 0.483337L39 23L-2.31961e-06 45.5167L-2.5034e-06 0.483337Z"
        />
      </svg>
      Kuuntele
    </button>
    """
  end

  def show_notes_button(assigns) do
    ~H"""
    <%= live_redirect(
      to:
        KapselistudioWeb.SubdomainRouter.Helpers.website_show_episode_path(
          KapselistudioWeb.Endpoint,
          :show_episode,
          assigns.number
        )
    ) do %>
      <button type="button" class="text-sm px-4 py-2 flex gap-4 items-center">
        <svg viewBox="0 0 63 15" class="w-4">
          <circle cx="7.5" cy="7.5" r="7.5" fill="currentColor" />
          <circle cx="31.5" cy="7.5" r="7.5" fill="currentColor" />
          <circle cx="55.5" cy="7.5" r="7.5" fill="currentColor" />
        </svg>
        Lue lisää
      </button>
    <% end %>
    """
  end
end
