export default function drawTrip(points) {
  var maymap = window.mymap;
  var trip_data = [
    [50.05552, 19.92819],
    [50.05639, 19.9292],
    [50.05745, 19.93042],
    [50.05831, 19.93217],
    [50.0589, 19.93327],
    [50.05983, 19.93273],
    [50.06045, 19.93253],
    [50.06045, 19.93253],
    [50.06199, 19.93177],
    [50.06263, 19.93203],
    [50.0639, 19.93352],
    [50.06524, 19.93505],
    [50.06615, 19.93623],
    [50.06631, 19.93905],
    [50.06762, 19.93869],
    [50.06887, 19.93829]
  ];

  var polyline = L.polyline(trip_data, { color: "green" }).addTo(mymap);
  mymap.fitBounds(polyline.getBounds());

  var start = L.circle([50.05552, 19.92819], {
    color: "blue",
    fillColor: "blue",
    fillOpacity: 0.4,
    radius: 4
  }).addTo(mymap);

  var end = L.circle([50.06887, 19.93829], {
    color: "blue",
    fillColor: "#blue",
    fillOpacity: 0.4,
    radius: 4
  }).addTo(mymap);
}
