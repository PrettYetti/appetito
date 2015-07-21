# appetito


## About
We are a platform (messaging) and content (restaurants) provider.
We are operating under the assumption that on a everyday basis people choose a restaurant based on location and convenience, but we have also accounted for the fact that cuisine, price range, and ratings are important.

## Team Members

- Eunice Kim, Product Manager
- Ciara Foran, Web Developer
- George Lu, Web Developer
- Remin Greenfield, Web Developer
- Scott Morgenthaler, UX Designer

## How it Works

The app is built around organizing events and inviting your friends to vote on a location relative to the location of everyone's location.

### Friends / Contacts

Each person has a privacy setting. Depending on this setting you can either add another person as a contact immediately or send a 'Friend Request'.

Search results appear instantly. And you can add or request friends in the modal.

### Notifications

The notification system uses single table inheritance to separate friend requests, event invites, event updates, and invite rsvps into seperate models that are recorded in the same table.

```ruby
class Notification < ActiveRecord::Base
	attr_accessor :message
  belongs_to :user
  belongs_to :event

  after_update :check_accept_status

  scope :friend_requests, -> { where(type: 'FriendRequest')}
  scope :event_invites, -> { where(type: 'EventInvite')}
  scope :event_updates, -> { where(type: 'EventUpdates')}
  scope :invite_rsvps, -> { where(type: 'InviteRSVPs')}
end

```

### Events

The events are the main focus of the app. Each user can see the events they are invited to and set their rsvp.

Once invited they set their location and can immediately start searching for restaurants.

Each invitee location that is set creates a marker in google maps and the bounds.

Then a radius is created based on distance of the min/max of the map's longitude and latitude. The search results are bound to that radius relative to the center of the map.

```javascript
	handler = Gmaps.build('Google');
	map = handler.buildMap({
	    provider: {
	      disableDefaultUI: true,
	      zoomControl: true,
        zoomControlOptions: {
            style: google.maps.ZoomControlStyle.SMALL,
            position: google.maps.ControlPosition.LEFT_TOP
        },
	      // draggable: false,
	      scrollwheel: false,
	      panControl: false
	      // pass in other Google Maps API options here
	    },
	    internal: {
	      id: 'map'
	    }
	  },
	  function(){
	  	json = <%=raw @hash.to_json %>
    	map = handler.map.serviceObject
    	center = map.center
	    markers = [];
	    searchMarkers = [];
	    bounds = new google.maps.LatLngBounds();
	    console.log(bounds, "these are the bounds")
	    maxlat = maxlng = minlat = minlng = undefined
	    json.forEach(function (obj) {
	    	
	    	buildMarker(obj);
	    	setRadius(obj.lat, obj.lng);
	    });
	    // debugger
	    
	    map.fitBounds(calibrate(bounds));
	    window.radius = measure (maxlat, maxlng, minlat, minlng)/1.5
	    window.center = map.getCenter();
	    console.log(radius)

	    //put ajax call here and access yelp API in ruby to hide secret
	  }
	);
	function measure(lat1, lon1, lat2, lon2){  // generally used geo measurement function
	    var R = 6378.137; // Radius of earth in KM
	    var dLat = (lat2 - lat1) * Math.PI / 180;
	    var dLon = (lon2 - lon1) * Math.PI / 180;
	    var a = Math.sin(dLat/2) * Math.sin(dLat/2) +
	    Math.cos(lat1 * Math.PI / 180) * Math.cos(lat2 * Math.PI / 180) *
	    Math.sin(dLon/2) * Math.sin(dLon/2);
	    var c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1-a));
	    var d = R * c;
	    return d * 1000; // meters
	}

	function calibrate(bounds) {
		var calibration =0.0007
		bounds.Ba.k -= calibration
		bounds.Ba.j += calibration
		bounds.ua.j -= calibration
		bounds.ua.k += calibration
		return bounds
	}



	function buildMarker(obj) {
		var myLatlng = new google.maps.LatLng(obj.lat, obj.lng)
		var contentString = obj.name
		var infowindow = new google.maps.InfoWindow({
			content: contentString
		})
		var marker =  new google.maps.Marker({
			position: myLatlng,
			map: handler.map.serviceObject,
			title: ""+obj.id
		})
		google.maps.event.addListener(marker, 'mouseover',function () {
			infowindow.open(map, marker);
		})

		google.maps.event.addListener(marker, 'mouseout', function () {
			infowindow.close();
		})
		bounds.extend(myLatlng)
		markers.push(marker)
	}

	function setRadius(lat,lng) {
		maxlat = Math.max(maxlat, lat) || lat
		minlat = Math.min(minlat, lat) || lat
		maxlng = Math.max(maxlng, lng) || lng
		minlng = Math.min(minlng, lng) || lng
	}

	function objectToMarker(object) {
		this.lat = object.latitude
		this.lng = object.longitude
		this.id = object.user_id
		this.name
	}
	
```

The app uses the Foursquare API where the search result is dictated by type of cuisine, price, and reservation status. The search results will generate new markers on the map and the user you can add the search results to a list of restaurants where other users can vote on a location.

```javascript
var pathname = window.location.pathname;
function getResults(lat, lng, cuis, prc, reservation){
	var baseURL = "https://api.foursquare.com/v2/venues/explore";
	var clientID = "?client_id=???";
	var clientSecret = "&client_secret=???";
	var version = "&v=20130815";
	var limit = "&limit=20";
	var rad
	if (window.radius == 0) {
		rad = ""
	} else ( rad = "&radius="+window.radius )

	var locale = "&ll="+lat+","+lng + rad;
	var cuisine = "&query="+ cuis;
	var price = (prc) ? "&price="+ prc : ""
	var photo = "&venuePhoto=1"
	var compile = clientID + clientSecret + version + limit + locale + cuisine + price + photo;
	var map = handler.map.serviceObject;
	console.log(compile)

	function parseVenue (venue) {
		var pricefix = (venue["venue"]["price"] === undefined) ? 0 : venue["venue"]["price"]["tier"]
		var reservationfix = (venue["venue"]["reservations"] === undefined) ? "Not Available" : venue["venue"]["reservations"]["url"]

		return {
			name: venue["venue"]["name"],
			cuisine: venue["venue"]["categories"][0]["shortName"],
			phone: venue["venue"]["contact"]["formattedPhone"],
			address: venue["venue"]["location"]["formattedAddress"].join(", "),
			rating: venue["venue"]["rating"],
			price: pricefix,
			reservations: reservationfix
		}
	}

	function renderResults (data) {
		if (reservation) {
		venues = []
			$(data["response"]["groups"]["0"]["items"]).each(function (index, venue) {
				if (venue["venue"]["reservations"]) {
					venues.push(venue)
				}
			})
		} else {
		venues = data["response"]["groups"]["0"]["items"]	
		}

		

		

		function buildMarker (venue) {
			this.name = venue["venue"]["name"]
			this.lat = venue["venue"]["location"]["lat"]
			this.lng = venue["venue"]["location"]["lng"]
			this.picture = "http://i.imgur.com/15cYFQt.png"
		}

		function makeVenue (venues, index) {
			var $newUl = $('<ul>', {id: index}).after($('<br>'));
			$('<li>').append($('<h2>').text(venues.name)).append($('<button>', {action: pathname+'/add_favorite', class: "favorite"}).text("Add me to favorites")).appendTo($newUl);
			$('<li>').text(venues.phone).appendTo($newUl);
			$('<li>').text(venues.address).appendTo($newUl);
			$('<li>').text("Rating: " + venues.rating).appendTo($newUl);
			$('<li>').text("Price: " + Array(venues.price+1).join("$")).appendTo($newUl);
			if (venues.reservations == "Not Available") {
				$('<li>').text("Reservations not available").appendTo($newUl);
			} else { 
				$('<li>').append($('<a>', {href: venues.reservations}).text("Make reservation")).appendTo($newUl);
			}
			$newUl.appendTo($('#results'));
			return $newUl
		}
		var $results = $('#results');
		$results.html('');

		$(venues).each(function(index, venue) {
			var $searchUl = makeVenue(parseVenue(venue), index)
			var markerInput = new buildMarker(venue)
			var myLatlng = new google.maps.LatLng(markerInput.lat, markerInput.lng)
			var contentString = markerInput.name
			var infowindow = new google.maps.InfoWindow({
				content: contentString
			})

			var marker =  new google.maps.Marker({
				position: myLatlng,
				map: map,
				title: markerInput.name,
				animation: google.maps.Animation.DROP,
				icon: markerInput.picture
			})

			google.maps.event.addListener(marker, 'mouseover',function () {
				infowindow.open(map, marker);
			})

			google.maps.event.addListener(marker, 'mouseout', function () {
				infowindow.close();
			})

			toggleSearchInfowindow($searchUl, marker)
			searchMarkers.push(marker)
		});

		// handler.addMarkers(markers).forEach(function(marker){

	
		// 	window.markers.push(marker)
		// })

		console.log(data)
		console.log(results)
	}

	$.ajax({
		url: baseURL + compile,
		dataType: 'json',
		success: function(data) {
			searchMarkers.forEach( function (marker) {
				marker.setMap(null)
			});
			searchMarkers = []
			renderResults(data);
			$('ul').find($('button')).on('click', function (event) {
				event.preventDefault();
				var index = $(this).parent().parent()[0].id
				var venue = parseVenue(venues[index])
				$.ajax({
					url: pathname+'/add_restaurant',
					type: 'POST',
					dataType: 'json',
					data: {restaurant: venue},
					success: function(data){
						if ($( "#favorite-wrapper:contains('"+data.name+"')" )[0] === undefined) {

							var $newDivPanel = $('<div></div>', {id: data.restaurant.id, class: "panel panel-default"})
							var $newDivPanelName = $('<div></div>', {class: "panel-heading" }).append($('<h4>').text(data.restaurant.name)).appendTo($newDivPanel);
							var $newDivPanelBody = $('<div></div>', {class: "panel-body" }).appendTo($newDivPanel)
							var $cuisine = $('<p></p>').text(data.restaurant.cuisine).appendTo($newDivPanelBody);
							var $price = $('<p></p>').text(Array(data.restaurant.price+1).join("$")).appendTo($newDivPanelBody);
							var $rating = $('<p></p>').text(data.restaurant.rating).appendTo($newDivPanelBody);
							if ( current_user.id == current_event.creator_id ) {
								var $confirmFavorite = $('<span aria-hidden="true" class="glyphicon glyphicon-ok favorite confirm cursor"></span>').appendTo($newDivPanelBody);
								toggleConfirm($confirmFavorite)
							}

							var $voteFavorite = $('<span aria-hidden="true" class="glyphicon glyphicon-heart favorited cursor">'+data.count+'</span>').appendTo($newDivPanelBody);

							var $newWrapper = $('<div></div>', {class: "col-xs-3 favorite-panel"}).append($newDivPanel);

							$('#favorite-wrapper').append($newWrapper)
							toggleFavorite($voteFavorite)

						}
					}
				})
				.done(function() {
					console.log("success");
				})
				.fail(function() {
					console.log("error");
				})
				.always(function() {
					console.log("complete");
				});

			})
		}
	})
}

function toggleFavorite($dom) {
	$($dom).on('click', function(){
		var id = $(this).parent().parent()[0].id
		var that = this
		$.ajax({
			url: pathname+'/toggle_favorite',
			type: 'POST',
			dataType: 'json',
			data: {restaurant: id},
			success: function (data) {
				$(that).text(data.count)
			}
		})
		.done(function() {
			console.log("success");
		})
		.fail(function() {
			console.log("error");
		})
		.always(function() {
			console.log("complete");
		});
		

	})
}

function toggleConfirm($dom) {
	$($dom).on('click', function(){
		var id = $(this).parent().parent()[0].id
		var that = this
		$.ajax({
			url: pathname + '/toggle_confirm',
			type: 'PUT',
			dataType: 'json',
			data: {restaurant: id},
			success: function(data){
				$('.confirmed').each(function () {
					$(this).removeClass('confirmed').addClass('confirm')
				})
				$(that).removeClass('confirm').addClass('confirmed')
				console.log(data)
			}
		})
		.done(function() {
			console.log("success");
		})
		.fail(function() {
			console.log("error");
		})
		.always(function() {
			console.log("complete");
		});
		
	})
}

function toggleSearchInfowindow($dom, marker) {
	$dom.on('mouseover', function () {
		google.maps.event.trigger(marker, 'mouseover');
	})

	$dom.on('mouseout', function () {
		google.maps.event.trigger(marker, 'mouseout');
	})
}

toggleFavorite($('.favorite'))
toggleFavorite($('.favorited'))
toggleConfirm($('.confirm'))
toggleConfirm($('.confirmed'))


$('#search').on('submit', function (event) {
	event.preventDefault();
	var cuisine = $(this).find('select').val()
	var price = $(this).find('input[name="price"]:checked').val()
	var reservation = $(this).find('input[name="reservation"]:checked').val()
	var lat = center.k
	var lng = center.D

	getResults(lat, lng, cuisine, price, reservation)
})
```

Each event also has a built in chat client using websocket.io and node.js which is deployed seperately.
