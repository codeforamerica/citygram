$(document).ready(function() {
  var options = {
    zoom: 14,
    center: [35.225803, -80.838625],
    tileLayer: { detectRetina: true },
    scrollWheelZoom: false,
  };
  var map = L.mapbox.map('map', 'ardouglass.h3mingmm', options);
});
