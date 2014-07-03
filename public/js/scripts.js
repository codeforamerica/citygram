$(document).ready(function() {
  app.hookupMap();
  app.hookupSteps();
});

var app = app || {};
app.state = {
  channel: 'sms',
  geom: undefined,
  publisher_id: undefined,
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
      featureGroup: drawnItems
    },
  });
  map.addControl(drawControl);

  map.on('draw:created', function(e) {
    // kill any existing layers. we only want one.
    // then add the new layers.
    // then update the state
    var geometry = drawnItems.addLayer(e.layer);
    console.log(geometry);
    // s.subscription.geom = JSON.stringify(geometry.toGeoJSON().features[0].geometry);
  });

  return {
    map: map,

  };
};

app.hookupSteps = function() {
  $('.startButton').on('click', function() {
    app.scrollToElement($('#step1'));
  });

  $('.somethingButton').on('click', function() {
    app.scrollToElement($('#step2'));
  });

  $('.mapButton').on('click', function() {
    app.scrollToElement($('#step3'));
  });

  $('.smsButton').on('click', function(event) {
    $(event.target).addClass('selected');
    $('.extraInfo').slideDown();
  });

  var finishSubscribe = function(e) {
    // TODO: animate the done checkmark at the same time
    e.preventDefault();
    $('#confirmation').slideDown();
    app.scrollToElement($('#confirmation'));
  };
  $('.subscribeButton').on('click', finishSubscribe);
  $('#subscribeForm').on('submit', finishSubscribe);

  $('.resetButton').on('click', function(event) {
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

app.submitSubscription = function(callback) {
  $.post('/subscriptions', { subscription: app.state }, callback); 
};
