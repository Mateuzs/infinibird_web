let path;

export default function drawTrip(points) {
  var maymap = window.mymap;

  if (path !== undefined) {
    mymap.removeLayer(path);
  }

  path = L.polyline(points, { color: "#d037e4" }).addTo(mymap);
  mymap.fitBounds(path.getBounds());

  //   var start = L.circle([50.05552, 19.92819], {
  //     color: "blue",
  //     fillColor: "blue",
  //     fillOpacity: 0.4,
  //     radius: 4
  //   }).addTo(mymap);

  //   var end = L.circle([50.06887, 19.93829], {
  //     color: "blue",
  //     fillColor: "#blue",
  //     fillOpacity: 0.4,
  //     radius: 4
  //   }).addTo(mymap);
}
