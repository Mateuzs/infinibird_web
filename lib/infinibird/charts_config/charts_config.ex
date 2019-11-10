defmodule Infinibird.ChartsConfig do
  @spec get_charts_config :: %{
          area_charts: [map, ...],
          column_charts: [map, ...],
          line_charts: [map, ...],
          pie_charts: [map, ...]
        }
  def get_charts_config() do
    %{
      #### COLUMN CHARTS CONFIGURATION ####

      column_charts: [
        %{
          description: %{
            title: "Profil prędkości kierowcy",
            vAxis: %{title: "Czas jazdy", format: "##,##%"},
            hAxis: %{title: "Prędkość w km/h"},
            colors: ["blue"]
          },
          data_extractor: fn data ->
            distance = Enum.reduce(data, 0, fn e, acc -> acc + e["distance_m"] end)

            [
              %{
                name: "Procent czasu w przedziale prędkości",
                data: [
                  [
                    "1-25km/h",
                    (Enum.reduce(
                       data,
                       0,
                       fn e, acc ->
                         acc + e["distance_m_speed_below_25_kmh"]
                       end
                     ) / (distance / 100))
                    |> Float.round(2)
                  ],
                  [
                    "26-50km/h",
                    (Enum.reduce(
                       data,
                       0,
                       fn e, acc ->
                         acc + e["distance_m_speed_25_50_kmh"]
                       end
                     ) / (distance / 100))
                    |> Float.round(2)
                  ],
                  [
                    "51-75km/h",
                    (Enum.reduce(
                       data,
                       0,
                       fn e, acc ->
                         acc + e["distance_m_speed_50_75_kmh"]
                       end
                     ) / (distance / 100))
                    |> Float.round(2)
                  ],
                  [
                    "76-100km/h",
                    (Enum.reduce(
                       data,
                       0,
                       fn e, acc ->
                         acc + e["distance_m_speed_75_100_kmh"]
                       end
                     ) / (distance / 100))
                    |> Float.round(2)
                  ],
                  [
                    "101-125km/h",
                    (Enum.reduce(
                       data,
                       0,
                       fn e, acc ->
                         acc + e["distance_m_speed_100_125_kmh"]
                       end
                     ) / (distance / 100))
                    |> Float.round(2)
                  ],
                  [
                    ">125km/h",
                    (Enum.reduce(
                       data,
                       0,
                       fn e, acc ->
                         acc + e["distance_m_speed_over_125_kmh"]
                       end
                     ) / (distance / 100))
                    |> Float.round(2)
                  ]
                ]
              }
            ]
          end
        }
      ],
      #### LINE CHARTS CONFIGURATION ####

      line_charts: [
        %{
          description: %{
            title: "Przejechane kilometry w ostatnich 7 dniach",
            vAxis: %{title: "Liczba kilometrów"},
            hAxis: %{title: "Dzień"},
            colors: ["purple"]
          },
          data_extractor: fn data ->
            week_data =
              Enum.sort_by(data, fn ride ->
                d = Date.from_iso8601!(ride["date"])
                {d.year, d.month, d.day}
              end)
              |> Enum.filter(fn ride ->
                Date.compare(Date.from_iso8601!(ride["date"]), Date.add(Date.utc_today(), -6)) !==
                  :lt
              end)
              |> Enum.group_by(fn ride -> ride["date"] end)

            [
              %{
                name: "kilometry",
                data: %{
                  "#{Date.add(Date.utc_today(), -6)}":
                    Map.get(week_data, "#{Date.add(Date.utc_today(), -6)}", [])
                    |> Enum.reduce(0, fn e, acc -> acc + e["distance_m"] end)
                    |> (fn e -> Kernel.trunc(e / 1000) end).(),
                  "#{Date.add(Date.utc_today(), -5)}":
                    Map.get(week_data, "#{Date.add(Date.utc_today(), -5)}", [])
                    |> Enum.reduce(0, fn e, acc -> acc + e["distance_m"] end)
                    |> (fn e -> Kernel.trunc(e / 1000) end).(),
                  "#{Date.add(Date.utc_today(), -4)}":
                    Map.get(week_data, "#{Date.add(Date.utc_today(), -4)}", [])
                    |> Enum.reduce(0, fn e, acc -> acc + e["distance_m"] end)
                    |> (fn e -> Kernel.trunc(e / 1000) end).(),
                  "#{Date.add(Date.utc_today(), -3)}":
                    Map.get(week_data, "#{Date.add(Date.utc_today(), -3)}", [])
                    |> Enum.reduce(0, fn e, acc -> acc + e["distance_m"] end)
                    |> (fn e -> Kernel.trunc(e / 1000) end).(),
                  "#{Date.add(Date.utc_today(), -2)}":
                    Map.get(week_data, "#{Date.add(Date.utc_today(), -2)}", [])
                    |> Enum.reduce(0, fn e, acc -> acc + e["distance_m"] end)
                    |> (fn e -> Kernel.trunc(e / 1000) end).(),
                  "#{Date.add(Date.utc_today(), -1)}":
                    Map.get(week_data, "#{Date.add(Date.utc_today(), -1)}", [])
                    |> Enum.reduce(0, fn e, acc -> acc + e["distance_m"] end)
                    |> (fn e -> Kernel.trunc(e / 1000) end).(),
                  "#{Date.utc_today()}":
                    Map.get(week_data, "#{Date.utc_today()}", [])
                    |> Enum.reduce(0, fn e, acc -> acc + e["distance_m"] end)
                    |> (fn e -> Kernel.trunc(e / 1000) end).()
                }
              }
            ]
          end
        },
        %{
          description: %{
            title: "Liczba przejazdów w ostatnich 7 dniach",
            vAxis: %{title: "Liczba przejazdów"},
            hAxis: %{title: "Dzień"},
            colors: ["red"]
          },
          data_extractor: fn data ->
            week_data =
              Enum.sort_by(data, fn ride ->
                d = Date.from_iso8601!(ride["date"])
                {d.year, d.month, d.day}
              end)
              |> Enum.filter(fn ride ->
                Date.compare(Date.from_iso8601!(ride["date"]), Date.add(Date.utc_today(), -6)) !==
                  :lt
              end)
              |> Enum.group_by(fn ride -> ride["date"] end)

            [
              %{
                name: "przejazdy",
                data: %{
                  "#{Date.add(Date.utc_today(), -6)}":
                    Map.get(week_data, "#{Date.add(Date.utc_today(), -6)}", [])
                    |> length(),
                  "#{Date.add(Date.utc_today(), -5)}":
                    Map.get(week_data, "#{Date.add(Date.utc_today(), -5)}", [])
                    |> length(),
                  "#{Date.add(Date.utc_today(), -4)}":
                    Map.get(week_data, "#{Date.add(Date.utc_today(), -4)}", [])
                    |> length(),
                  "#{Date.add(Date.utc_today(), -3)}":
                    Map.get(week_data, "#{Date.add(Date.utc_today(), -3)}", [])
                    |> length(),
                  "#{Date.add(Date.utc_today(), -2)}":
                    Map.get(week_data, "#{Date.add(Date.utc_today(), -2)}", [])
                    |> length(),
                  "#{Date.add(Date.utc_today(), -1)}":
                    Map.get(week_data, "#{Date.add(Date.utc_today(), -1)}", [])
                    |> length(),
                  "#{Date.utc_today()}":
                    Map.get(week_data, "#{Date.utc_today()}", [])
                    |> length()
                }
              }
            ]
          end
        }
      ],
      #### AREA CHARTS CONFIGURATION ####

      area_charts: [
        %{
          description: %{
            title: "Czas spędzony w samochodzie w ostatnich 7 dniach",
            vAxis: %{title: "Liczba minut"},
            hAxis: %{title: "Dzień"},
            colors: ["green"],
            pointSize: 5
          },
          data_extractor: fn data ->
            week_data =
              Enum.sort_by(data, fn ride ->
                d = Date.from_iso8601!(ride["date"])
                {d.year, d.month, d.day}
              end)
              |> Enum.filter(fn ride ->
                Date.compare(Date.from_iso8601!(ride["date"]), Date.add(Date.utc_today(), -6)) !==
                  :lt
              end)
              |> Enum.group_by(fn ride -> ride["date"] end)

            [
              %{
                name: "minuty",
                data: %{
                  "#{Date.add(Date.utc_today(), -6)}":
                    Map.get(week_data, "#{Date.add(Date.utc_today(), -6)}", [])
                    |> Enum.reduce(0, fn e, acc -> acc + e["travel_time_minutes"] end),
                  "#{Date.add(Date.utc_today(), -5)}":
                    Map.get(week_data, "#{Date.add(Date.utc_today(), -5)}", [])
                    |> Enum.reduce(0, fn e, acc -> acc + e["travel_time_minutes"] end),
                  "#{Date.add(Date.utc_today(), -4)}":
                    Map.get(week_data, "#{Date.add(Date.utc_today(), -4)}", [])
                    |> Enum.reduce(0, fn e, acc -> acc + e["travel_time_minutes"] end),
                  "#{Date.add(Date.utc_today(), -3)}":
                    Map.get(week_data, "#{Date.add(Date.utc_today(), -3)}", [])
                    |> Enum.reduce(0, fn e, acc -> acc + e["travel_time_minutes"] end),
                  "#{Date.add(Date.utc_today(), -2)}":
                    Map.get(week_data, "#{Date.add(Date.utc_today(), -2)}", [])
                    |> Enum.reduce(0, fn e, acc -> acc + e["travel_time_minutes"] end),
                  "#{Date.add(Date.utc_today(), -1)}":
                    Map.get(week_data, "#{Date.add(Date.utc_today(), -1)}", [])
                    |> Enum.reduce(0, fn e, acc -> acc + e["travel_time_minutes"] end),
                  "#{Date.utc_today()}":
                    Map.get(week_data, "#{Date.utc_today()}", [])
                    |> Enum.reduce(0, fn e, acc -> acc + e["travel_time_minutes"] end)
                }
              }
            ]
          end
        }
      ],
      #### PIE CHARTS CONFIGURATION ####

      pie_charts: [
        %{
          description: %{
            title: "Liczba przyspieszeń oraz zahamowań pojazdu",
            colors: ["green", "orange"]
          },
          donut: true,
          data_extractor: fn data ->
            [
              [
                "Liczba przyspieszeń",
                Enum.reduce(data, 0, fn e, acc -> acc + e["accelerations"] end)
              ],
              [
                "Liczba zahmowań",
                Enum.reduce(data, 0, fn e, acc -> acc + e["decelerations"] end)
              ]
            ]
          end
        },
        %{
          description: %{
            title: "Liczba manewrów skrętu pojazdu",
            colors: ["purple", "cyan"]
          },
          donut: true,
          data_extractor: fn data ->
            [
              [
                "Liczba skrętów w lewo",
                Enum.reduce(data, 0, fn e, acc -> acc + e["left_turns"] end)
              ],
              [
                "Liczba skrętów w prawo",
                Enum.reduce(data, 0, fn e, acc -> acc + e["right_turns"] end)
              ]
            ]
          end
        }
      ]
    }
  end
end
