function initMap(sitingsJSON, id) {
  var sitings = JSON.parse(sitingsJSON);

  var zoom = 3;
  var lat = 20;
  var lng = 0;
  if (id) {
    zoom = 8;
    lat = sitings[id].coords.lat
    lng = sitings[id].coords.lng
  }

	var options = {
		center: new google.maps.LatLng(lat, lng),
		zoom: zoom,
		styles: [{
        "featureType": "administrative",
        "elementType": "geometry",
        "stylers": [{
          "visibility": "off"
        }]
      }, {
        "featureType": "administrative.country",
        "elementType": "geometry.stroke",
        "stylers": [{
          "visibility": "on"
        }]
      }, {
        "featureType": "administrative.province",
        "elementType": "geometry.stroke",
        "stylers": [{
          "visibility": "on"
        }]
      }, {
        "featureType": "administrative.locality",
        "elementType": "geometry.stroke",
        "stylers": [{
          "visibility": "on"
        }]
      }, {
        "featureType": "administrative.neighborhood",
        "elementType": "geometry.stroke",
        "stylers": [{
          "visibility": "on"
        }]
      }, {
        "featureType": "administrative.land_parcel",
        "elementType": "geometry.stroke",
        "stylers": [{
          "visibility": "on"
        }]
      }]
	};

	var map = new google.maps.Map(document.getElementById('map'), options);
  var infoWindow = new google.maps.InfoWindow();

	for (var key in sitings) {
		addMarker(key, sitings[key])
	}

	function addMarker(key, siting) {
		var marker = new google.maps.Marker({
			position: siting.coords,
			map: map
		});

    if (key == id) {
      openInfoWindow();
    }

		marker.addListener('click', function(){
      openInfoWindow();
		});

    function openInfoWindow() {
      infoWindow.setContent('<a href="' + siting.url + '"><img src="' + siting.image + '"></a>');
      infoWindow.open(map, marker);
    }
	}
}