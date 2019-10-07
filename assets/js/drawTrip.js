let path;
let startMarker;
let endMarker;
let mapPoints;

const mapManeuverTypeToColor = maneuver => {
  const maneuverColorMap = {
    acceleration: "#53eb34",
    accelerationFollowedByDeceleration: "#34eb67",
    accelerationOverloadEvent: "#96eb34",
    deceleration: "#ebcd34",
    decelerationFollowedByAcceleration: "#e8eb34",
    constantSpeed: "#34ebdf",
    stop: "#d634eb",
    rightTurn: "#a100f1",
    leftTurn: "#f100a1",
    activity: "#9ad6e5",
    jerking: "#eb5634",
    sharp: "#a40000"
  };

  if (!maneuverColorMap[maneuver]) {
    return "#000000";
  }

  return maneuverColorMap[maneuver];
};

const translateManeuverType = maneuver => {
  const maneuverTypeMap = {
    acceleration: "przyspieszenie",
    accelerationFollowedByDeceleration: "przyspieszenie po hamowaniu",
    deceleration: "zwalnianie",
    decelerationFollowedByAcceleration: "zwalnianie po przyspieszeniu",
    accelerationOverloadEvent: "przeciązenie przyspieszenia",
    constantSpeed: "prędkość stała",
    stop: "stop",
    rightTurn: "skręt w prawo",
    leftTurn: "skręt w lewo",
    activity: "aktywność",
    jerking: "szarpanie",
    sharp: "szarpnięcie"
  };

  if (!maneuverTypeMap[maneuver]) {
    return "nierozpoznany manewr";
  }

  return maneuverTypeMap[maneuver];
};

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
      color: mapManeuverTypeToColor(point.man_type),
      fillColor: mapManeuverTypeToColor(point.man_type),
      fillOpacity: 1,
      radius: 10
    }).addTo(mymap);

    var kmh = (point.mps * 3.6).toFixed(2);
    mapPoint.bindPopup(
      `
       <h6> ${translateManeuverType(point.man_type)}</h6>
       <b>długość geograficzna: ${point.lon} 
       </br>szerokość geograficzna: ${point.lat}
       </br>wysokość nad poziomem morza: ${Math.trunc(point.alt)} m
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
