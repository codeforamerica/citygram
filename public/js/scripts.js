$(document).ready(function() {
  app.hookupMap();
  app.hookupSteps();
});

var app = app || {};
app.state = {
  channel: 'sms',
  geom: undefined,
  publisher_id: undefined,
  contact: undefined,
};

app.hookupMap = function() {
  var options = {
    zoom: 14,
    center: [35.225803, -80.838625],
    tileLayer: { detectRetina: true },
    scrollWheelZoom: false,
  };
  var map = app.map = L.mapbox.map('map', 'ardouglass.h3mingmm', options);

  // Initialise the FeatureGroup to store editable layers
  var drawnItems = new L.FeatureGroup();
  map.addLayer(drawnItems);

  // Initialise the draw control and pass it the FeatureGroup of editable layers
  // TODO: Limit it to the polygon tool. Hint to start drawing?
  var drawControl = new L.Control.Draw({
    draw: {
      polyline: false,
      rectangle: false,
      circle: false,
      marker: false,
    },
    edit: {
      featureGroup: drawnItems,
      edit: false,
      remove: false,
    },
  });
  map.addControl(drawControl);

  map.on('draw:drawstart', function(e) {
    if (app.prevLayer) map.removeLayer(app.prevLayer);
  });

  map.on('draw:created', function(e) {
    var geometry = drawnItems.addLayer(e.layer);
    app.state.geom = JSON.stringify(geometry.toGeoJSON().features[0].geometry);
    app.prevLayer = e.layer;
  });
};

app.hookupSteps = function() {
  $('.startButton').on('click', function() {
    app.scrollToElement($('#step1'));
  });

  $('.publisher:not(.soon)').on('click', function(event) {
    $('.publisher').removeClass('selected');

    var $publisher = $(event.currentTarget);
    app.state.publisher_id = $publisher.data('publisher-id');
    $publisher.addClass('selected');

    app.scrollToElement($('#step2'));
  });

  $('.mapButton').on('click', function() {
    app.scrollToElement($('#step3'));
  });

  $('.leaflet-draw-draw-polygon').on('click', function() {
    $('.drawHint').fadeOut();
  });

  $('.smsButton').on('click', function(event) {
    $(event.target).addClass('selected');
    $('.extraInfo').slideDown();
  });

  var finishSubscribe = function(e) {
    // TODO: animate the done checkmark at the same time
    e.preventDefault();
    app.state.contact = $('.phoneNumber').val();

    app.submitSubscription(function() {
      $('#confirmation').slideDown();
      app.scrollToElement($('#confirmation'));
    });
  };
  $('.subscribeButton').on('click', finishSubscribe);
  $('#subscribeForm').on('submit', finishSubscribe);

  $('.resetButton').on('click', function(event) {
    app.resetState();
    app.scrollToElement($('#step1'));

    // Hide after we've scrolled up.
    setTimeout(function() {
      $('#confirmation').hide();
    }, 800);
  });

  $('#geolocateForm').on('submit', function(e) {
    e.preventDefault();
    var address = $('#geolocate').val();
    app.geocode(address, function(latlng) {
      app.map.setView(latlng, 15);
    });
  });
};

app.scrollToElement = function(el) {
  $('html,body').animate({
    scrollTop: el.offset().top
  }, 800);
};

app.geocode = function(city, callback, context) {
 var url = 'https://maps.googleapis.com/maps/api/geocode/json?address=' + encodeURIComponent(city);

 $.getJSON(url, function(response) {
    if (response.error || response.results.length === 0) {
      console.log('Unable to geocode city. Womp Womp.', response.error);
    }

    // Get the coordinates for the center of the city
    var location = response.results[0].geometry.location;
    var latlng = [location.lat, location.lng];
    callback.call(context || this, latlng);
  });
};

app.resetState = function() {

  app.state.publisher_id = undefined;
  $('.publisher').removeClass('selected');

  app.state.geom = undefined;
  if (app.prevLayer) app.map.removeLayer(app.prevLayer);
  // Let's leave the type and phone number in place, for easy re-subscribe
};

app.submitSubscription = function(callback) {
  $.post('/subscriptions', { subscription: app.state }, callback); 
};
