let path;
let startMarker;
let endMarker;
let mapPoints;

export default function drawTrip(points) {
  var maymap = window.mymap;

  if (path !== undefined) {
    mymap.removeLayer(path);
    mymap.removeLayer(startMarker);
    mymap.removeLayer(endMarker);
    mapPoints.forEach(point => mymap.removeLayer(point));
  }

  path = L.polyline(points, { color: "#0c79f5" }).addTo(mymap);

  mapPoints = points.map(point => {
    const mapPoint = L.circle(point, {
      color: "#d037e4",
      fillColor: "#d037e4",
      fillOpacity: 1,
      radius: 10
    }).addTo(mymap);

    mapPoint.bindPopup(
      "<b>Hello visitor!</b></br>Here we are going to add interesting information :)</br>Stay tuned..."
    );

    return mapPoint;
  });

  startMarker = L.marker(points.shift()).addTo(mymap);
  endMarker = L.marker(points.pop()).addTo(mymap);

  mymap.fitBounds(path.getBounds());
}
