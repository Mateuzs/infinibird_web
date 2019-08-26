// webpack automatically bundles all modules in your
// entry points. Those entry points can be configured
// in "webpack.config.js".
//
// Import dependencies

import "phoenix_html";
import Chartkick from "chartkick";
import L from "leaflet";
import LiveSocket from "phoenix_live_view";

// Import local files
import css from "../css/app.scss";
import integrateMap from "../js/integrateMap";
import drawTrip from "../js/drawTrip";

// // Live View

let liveSocket = new LiveSocket("/live");
liveSocket.connect();

// configure charts
Chartkick.configure({ language: "pl" });
window.Chartkick = Chartkick;

window.L = L;
window.integrateMap = integrateMap;
window.drawTrip = drawTrip;
