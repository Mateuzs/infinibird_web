defmodule Infinibird.ChartsConfig do
  def getChartsConfig() do
    %{
      column_charts: [
        %{
          description: %{
            title: "Profil prędkości kierowcy",
            vAxis: %{title: "Czas jazdy", format: "##,##%"},
            hAxis: %{title: "Prędkość w km/h"},
            colors: ["blue"]
          },
          data_extractor: fn -> nil end
        }
      ],
      line_charts: [],
      area_charts: [
        %{
          description: %{
            title: "Czas spędzony w samochodzie w ostatnich 7 dniach",
            vAxis: %{title: "Liczba minut"},
            hAxis: %{title: "Dzień"},
            colors: ["green"],
            pointSize: 5
          },
          data_extractor: fn -> nil end
        }
      ],
      pie_charts: [
        %{
          description: %{
            title: "Liczba przyspieszeń oraz zahamowań pojazdu",
            colors: ["green", "orange"]
          },
          donut: true,
          data_extractor: fn -> nil end
        },
        %{
          description: %{
            title: "Liczba manewrów skrętu pojazdu",
            colors: ["purple", "cyan"]
          },
          donut: true,
          data_extractor: fn -> nil end
        }
      ]
    }
  end
end
