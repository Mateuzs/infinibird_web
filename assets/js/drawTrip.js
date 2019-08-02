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

  const pathPoints = points.sort((e1, e2) => {
    const a = e1.tim.split(":");
    const sum1 = a[0] * 3600 + a[1] * 60 + a[2];
    const b = e2.tim.split(":");
    const sum2 = b[0] * 3600 + b[1] * 60 + b[2];

    return sum1 - sum2;
  });

  path = L.polyline(pathPoints, { color: "#0c79f5" }).addTo(mymap);

  mapPoints = points.map(point => {
    const mapPoint = L.circle(point, {
      color: "#d037e4",
      fillColor: "#d037e4",
      fillOpacity: 1,
      radius: 10
    }).addTo(mymap);

    var kmh = (point.mps * 3.6).toFixed(2);
    mapPoint.bindPopup(
      `<b>długość geograficzna: ${point.lon} 
       </br>szerokość geograficzna: ${point.lat}
       </br>wysokość nad poziomem morza: ${point.alt} m
       </br>prędkość: ${kmh} km/h
       </br>czas: ${point.tim}

       `
    );

    return mapPoint;
  });

  startMarker = L.marker(points.shift()).addTo(mymap);
  endMarker = L.marker(points.pop()).addTo(mymap);

  mymap.fitBounds(path.getBounds());
}
