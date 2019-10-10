defmodule Infinibird.ChartsConfig do
  @spec getChartsConfig :: %{
          area_charts: [map, ...],
          column_charts: [map, ...],
          line_charts: [map, ...],
          pie_charts: [map, ...]
        }
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
      line_charts: [
        %{
          description: %{
            title: "Przejechane kilometry w ostatnich 7 dniach",
            vAxis: %{title: "Liczba kilometrów"},
            hAxis: %{title: "Dzień"},
            colors: ["purple"]
          },
          data_extractor: fn -> nil end
        },
        %{
          description: %{
            title: "Liczba przejazdów w ostatnich 7 dniach",
            vAxis: %{title: "Liczba przejazdów"},
            hAxis: %{title: "Dzień"},
            colors: ["red"]
          },
          data_extractor: fn -> nil end
        },
        %{
          description: %{
            title: "Przejechane kilometry na przestrzeni 3 miesięcy",
            vAxis: %{title: "Liczba kilometrów"},
            hAxis: %{title: "Dzień"}
          },
          data_extractor: fn -> nil end
        }
      ],
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
