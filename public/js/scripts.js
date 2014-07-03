$(document).ready(function() {
  var map = app.hookupMap();
  app.hookupSteps();
  
  // Add geometry to map
  // Set geom in subscription
});

var app = app || {};
app.state = {
  channel: 'sms',
  geom: undefined,
  publisher_id: undefined,
};

app.init = function() {

};

app.submitSubscription = function(callback) {
  $.post('/subscriptions', { subscription: app.state }, callback); 
};


app.scrollToElement = function(el) {
  $('html,body').animate({
    scrollTop: el.offset().top
  }, 800);
};

app.hookupMap = function() {
  var options = {
    zoom: 14,
    center: [35.225803, -80.838625],
    tileLayer: { detectRetina: true },
    scrollWheelZoom: false,
  };
  var map = L.mapbox.map('map', 'ardouglass.h3mingmm', options);

  // Initialise the FeatureGroup to store editable layers
  var drawnItems = new L.FeatureGroup();
  map.addLayer(drawnItems);

  // Initialise the draw control and pass it the FeatureGroup of editable layers
  // TODO: Limit it to the polygon tool. Hint to start drawing?
  var drawControl = new L.Control.Draw({
    edit: { featureGroup: drawnItems }
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

  $('.subscribeButton').on('click', function(event) {
    // TODO: animate the done checkmark at the same time
    $('#confirmation').slideDown();
    app.scrollToElement($('#confirmation'));
  });

  $('.resetButton').on('click', function(event) {
    app.scrollToElement($('#step1'));

    // Hide after we've scrolled up.
    setTimeout(function() {
      $('#confirmation').hide();
    }, 800);
  });
};
