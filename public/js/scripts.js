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
    zoom: 13,
    center: [47.604432, -122.336014],
    tileLayer: { detectRetina: true },
    scrollWheelZoom: false,
  };
  var mapId = $('meta[name=mapId]').attr('content');
  var map = app.map = L.mapbox.map('map', mapId, options);
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

    // Update the confirmation section with the name
    $('.confirmationType').html($publisher.data('publisher-title'));

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

  var prevMarker, prevCircle;
  var geolocate = function(e) {
    e.preventDefault();
    var address = $('#geolocate').val();
    app.geocode(address, function(latlng) {
      app.map.setView(latlng, 15);
      updateGeometry(latlng);

      if (prevMarker) app.map.removeLayer(prevMarker);
      if (prevCircle) app.map.removeLayer(prevCircle);

      prevMarker = L.marker(latlng).addTo(app.map);
      prevCircle = L.circle(latlng, 1000).addTo(app.map);
    });
  };

  var BOUNDING_DISTANCE_IN_KM = 1;
  var updateGeometry = function(latlng) {
    var center = new LatLon(latlng[0], latlng[1]);
    var bbox = center.boundingBox(BOUNDING_DISTANCE_IN_KM);
    app.state.geom = JSON.stringify({
      type: 'Polygon',
      coordinates: bbox,
    });
  };

  $('#geolocateForm').on('submit', geolocate);
  $('.geolocateButton').on('click', geolocate);
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

  // Let's leave the location and phone number in place, for easy re-subscribe
};

app.submitSubscription = function(callback) {
  $.post('/subscriptions', { subscription: app.state }, callback); 
};
