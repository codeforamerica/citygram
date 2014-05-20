var map = L.map('map').setView([35.2031535, -80.8395259], 9);

L.tileLayer('http://{s}.tiles.mapbox.com/v3/ardouglass.h3mingmm/{z}/{x}/{y}.png', {
    attribution: 'Map data &copy; <a href="http://openstreetmap.org">OpenStreetMap</a> contributors, <a href="http://creativecommons.org/licenses/by-sa/2.0/">CC-BY-SA</a>, Imagery © <a href="http://mapbox.com">Mapbox</a>',
    maxZoom: 18
}).addTo(map);

$("#message-method .btn").click(function(e) {
  e.preventDefault();
  var id = $(this).attr("id");

  $("#contact-method").val(id);
  $("#contact-info").attr("placeholder", $(this).data("placeholder"));
  $("#contact-info").attr("type", id);

  $("#subscription-info").removeClass("hidden");
});