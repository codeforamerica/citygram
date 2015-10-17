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

app.eventMarkers = new L.FeatureGroup();

app.hookupMap = function() {
  var center = JSON.parse($('meta[name=mapCenter]').attr('content'));
  var options = {
    zoom: 13,
    center: center,
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

  $('.publisher:not(.soon)').on('mouseover', function(event) {
    $('.publisher').removeClass('is-active');

    var $publisher = $(event.currentTarget);
    $publisher.addClass('is-active');
  });

  $('.publisher:not(.soon)').on('mouseout', function(event) {
    $('.publisher').removeClass('is-active');
  });

  $('.publisher:not(.soon) .publisher-btn').on('click', function(event) {
    $('.publisher').removeClass('selected');

    var $publisher = $(this).parents('.publisher:not(.soon)');
    $publisher.addClass('selected');

    app.setPublisher($publisher);

    // Remove disabled state styling from subscribe buttons
    $('.smsButton, .emailButton').removeClass('disabledButton');

    // Hide disabled subscribe message
    $('.disabledInfo').hide();

    // update events for the new publisher
    app.updateEvents(app.map.getBounds());

    app.scrollToElement($('#step2'));
  });

  app.handleChannelClick = function(channel, channelBtn) {
    if (channelBtn.hasClass('disabledButton')) {
      $('.disabledInfo').slideDown();
    } else {
      app.setChannel(channel, channelBtn);
    };
  }

  app.setChannel = function(channel, channelBtn) {
    $('.channelButtons .selected').removeClass('selected');
    channelBtn.addClass('selected');
    $('.channel-inputs :visible').hide();
    $('.channel-inputs .js-channel-' + channel).show();
    app.state.channel = channel;
    $('.extraInfo').slideDown();
    $('.js-confirm-channel').hide();
    $('.js-confirm-' + channel).show();
  }

  $('.smsButton').on('click', function(event) {
    app.handleChannelClick('sms', $(event.target));
  });

  $('.emailButton').on('click', function(event) {
    app.handleChannelClick('email', $(event.target));
  });

  var finishSubscribe = function(e) {
    // TODO: animate the done checkmark at the same time
    e.preventDefault();

    // TODO: handle email and webhooks also
    app.state.phone_number = $('.phoneNumber').val();
    app.state.email_address = $('.emailAddress').val();

    app.submitSubscription(function(subscription) {
      $('#confirmation').slideDown();
      app.scrollToElement($('#confirmation'));
      $('#view-subscription').attr('href', '/digests/'+subscription.id+'/events')
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
  app.geolocate = function(e) {
    e && e.preventDefault();
    var address = $('#geolocate').val();
    if (! address) { return }

    var city = $('.publisher.selected').data('publisher-city');
    var state = $('.publisher.selected').data('publisher-state');
    var radiusMiles = parseFloat($('#user-selected-radius').val());
    var radiusKm =radiusMiles * 1.60934
    var radiusMeters = radiusKm * 1000;
    var oneWeekAgo = new Date();
    oneWeekAgo.setDate(oneWeekAgo.getDate() - 7);

    app.geocode(address, city, state, function(latlng) {
      // Set the new app state
      var center = new LatLon(latlng[0], latlng[1]);
      var bboxDistance = radiusKm;
      var bbox = center.boundingBox(bboxDistance);
      app.state.geom = JSON.stringify({
        type: 'Polygon',
        coordinates: [bbox],
      });

      // Remove old layers
      if (prevMarker) app.map.removeLayer(prevMarker);
      if (prevCircle) app.map.removeLayer(prevCircle);

      // Preserve references to new layers
      prevMarker = L.marker(latlng).addTo(app.map);
      prevCircle = L.circle(latlng, radiusMeters, { color:'#0B377F' }).addTo(app.map);

      if (app.eventsArePolygons) {
        app.updateEventsForGeometry(app.state.geom, function(events) {
          app.copyEventTitleToMarker(events, prevMarker);
        });
      }

      // fit bounds
      app.map.fitBounds(prevCircle.getBounds());

      // Frequency estimate
      app.getEventsCount(app.state.publisher_id, app.state.geom, oneWeekAgo, function(response) {
        $('#freqRadius').html(radiusMiles + ' mi');
        $('#freqAddress').html(address);
        $('#freqNum').html(response.events_count + ' citygrams');
      });

    });
  };

  app.map.on('zoomend', function() {
    app.updateEvents(app.map.getBounds());
  });
  $('.publisher:not(.soon)').on('click', function(e) {
    if ($('#geolocate').val().trim() !== '') app.geolocate();
  });
  $('#user-selected-radius').on('change', app.geolocate);
  $('#geolocate').on('change', app.geolocate);
  $('#geolocateForm').on('submit', function(){ return false });

};

app.copyEventTitleToMarker = function(events, marker) {
  var surroundingEvent;
  var markerGeoJSON = marker.toGeoJSON();

  events.forEach(function(event) {
    var polygon = {"type": "Feature", geometry: JSON.parse(event.geom)};
    if (turf.inside(markerGeoJSON, polygon)) {
      surroundingEvent = event;
    }
  });

  if (surroundingEvent) {
    marker.bindPopup("<p>"+app.hyperlink(surroundingEvent.title)+"</p>").openPopup();
  }
}

app.setPublisher = function($publisher) {
  app.state.publisher_id = $publisher.data('publisher-id');
  app.eventsArePolygons = $publisher.data('publisher-events-are-polygons');

  if ($publisher.data('publisher-event-display-endpoint')) {
    app.eventDisplayEndpoint = $publisher.data('publisher-event-display-endpoint');
  } else {
    app.eventDisplayEndpoint = '/publishers/'+app.state.publisher_id+'/events';
  }

  $('.js-dot-legend').css('visibility', app.eventsArePolygons ? 'hidden' : 'visible');
  $('.confirmationType').html($publisher.data('publisher-title'));
}

app.hyperlink = Autolinker.link;

// Populate events
app.updateEvents = function(bounds) {
  var mapGeometry = {
    type: 'Polygon',
    coordinates: [[
      [bounds._southWest.lng, bounds._northEast.lat],
      [bounds._northEast.lng, bounds._northEast.lat],
      [bounds._northEast.lng, bounds._southWest.lat],
      [bounds._southWest.lng, bounds._southWest.lat],
      [bounds._southWest.lng, bounds._northEast.lat]
    ]]
  }

  app.updateEventsForGeometry(JSON.stringify(mapGeometry), function(events) {
    app.eventMarkers.eachLayer(function(layer) {
      app.map.removeLayer(layer);
    });

    // tiny radius mimics an address point inside event polygon
    if (app.eventsArePolygons) { app.selectTinyRadius(); }

    events.forEach(function(event, index) {
      var marker = app.displayEventMarker(event);

      if (index == 0 && ! app.eventsArePolygons) {
        marker.openPopup();
      }
    });
  });
};

app.selectTinyRadius = function() {
  var tinyRadius = '.001'
  var $select = $('#user-selected-radius');
  if ($select.find('option[value="' + tinyRadius + '"]').length === 0) {
    $select.prepend('<option value="' + tinyRadius + '">Within 1/100 mile (only the address)</option>');
  }
  $select.val(tinyRadius);
  app.geolocate();
}

app.displayEventMarker = function(event) {
  var geometry = JSON.parse(event.geom);
  var marker;
  var html = "<p>"+app.hyperlink(event.title)+"</p>"
  if (app.eventsArePolygons) {
    marker = L.geoJson({"type": "Feature", "geometry": geometry});
  } else {
    marker = L.circleMarker([geometry.coordinates[1], geometry.coordinates[0]], { radius: 6, color: '#FC442A' })
  }
  marker.addTo(app.map).bindPopup(html);

  app.eventMarkers.addLayer(marker);
  return marker;
}

app.updateEventsForGeometry = function(geometry, callback){
  if (!app.state.publisher_id) return;
  $.getJSON(app.eventDisplayEndpoint, { geometry: geometry }, callback);
};

app.getEventsCount = function(publisherId, geometry, since, callback){
  if (!publisherId) return;
  $.getJSON('/publishers/'+publisherId+'/events_count', { geometry: geometry, since: since }, callback);
};

app.scrollToElement = function(el) {
  $('html,body').animate({
    scrollTop: el.offset().top
  }, 800);
};

app.geocode = function(address, city, state, callback, context) {
  var url = 'https://maps.googleapis.com/maps/api/geocode/json?address=';
  if(city === 'Triangle NC'){
    address += ' Triangle, NC';
    url += encodeURIComponent(address);
  } else {
    url += encodeURIComponent(address);
    url += '&components=locality:' + encodeURIComponent(city);
    url += '|administrative_area:' + encodeURIComponent(state);
  }

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
  app.eventDisplayEndpoint = undefined;
  $('.publisher').removeClass('selected');

  // Let's leave the location and phone number in place, for easy re-subscribe
};

app.submitSubscription = function(callback) {
  $.post('/subscriptions', { subscription: app.state }, callback);
};
