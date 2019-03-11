// webpack automatically bundles all modules in your
// entry points. Those entry points can be configured
// in "webpack.config.js".
//
// Import dependencies
import "phoenix_html";
import Chartkick from "chartkick";
import L from "leaflet";

// Import local files
import css from "../css/app.css";

// do JS stuff
window.Chartkick = Chartkick;
window.L = L;
