function initMap(sitingsJSON) {

	var options = {
		center: new google.maps.LatLng(20, 0),
		zoom: 3,
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

	var sitings = JSON.parse(sitingsJSON);

	for (var siting of sitings) {
		addMarker(siting)
	}

	function addMarker(props) {
		var marker = new google.maps.Marker({
			position: props.coords,
			map: map
		});

		var infoWindow = new google.maps.InfoWindow({
			content: ('<img src="' + props.image + '" />')
		});

		marker.addListener('mouseover', function(){
			infoWindow.open(map, marker);
		});

		marker.addListener('mouseout', function() {
			infoWindow.close();
		});

		marker.addListener('click', function(){
			window.location.href = props.url;
		});
	}
}