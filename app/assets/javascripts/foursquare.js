window.onload = function () {

console.log("fivesquare loaded")

var pathname = window.location.pathname;
function getResults(lat, lng, cuis, prc, reservation){
	var baseURL = "https://api.foursquare.com/v2/venues/explore";
	var clientID = "?client_id=CSXMPXYF20VXWMX4Z0BTKHVT5VGRKA1E3ZAPKCE04ELOMX3W";
	var clientSecret = "&client_secret=LQ2UIGEDAP0O5CFMQEMEYEM1KORYH4ISVPXLRSHGYNU1LMOZ";
	var version = "&v=20130815";
	var limit = "&limit=20";
	var locale = "&ll="+lat+","+lng+"&radius="+window.radius;
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

							var $newWrapper = $('<div></div>', {class: "col-xs-3"}).append($newDivPanel);

							$('#favorite-wrapper').append($newWrapper)
							toggleFavorite($voteFavorite)

							// var $name = $('<li></li>').append($('<h4>').text(data.restaurant.name));
							// var $cuisine = $('<li></li>').text(data.restaurant.cuisine);
							// var $price = $('<li></li>').text(Array(data.restaurant.price+1).join("$"));
							// var $rating = $('<li></li>').text(data.restaurant.rating);
							// var $confirmFavorite = $('<span aria-hidden="true" class="glyphicon glyphicon-ok favorite confirm cursor"></span>')
							// var $voteFavorite = $('<span aria-hidden="true" class="glyphicon glyphicon-heart favorite cursor"></span>')

							// var $newFavoriteUl = $('<ul>', {id: data.restaurant.id}).append($name, $cuisine, $price, $rating, $confirmFavorite, $voteFavorite)
							// var $newFavoriteLi = $('<li>', {id: data.restaurant.id, class: "col-xs-6 col-sm-3"}).append($newFavoriteUl)
							// $('#favorite-wrapper').append($newFavoriteLi)
							// toggleFavorite($voteFavorite)
							// toggleConfirm($confirmFavorite)
							// console.log('trying to add stuff')
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

// $('.fs').on('click', function(event){

//   event.preventDefault();
//   var searchDegree = 1000
  // var lat = center.k
  // var lng = center.B
//   console.log(lat,lng)


//   //fix this to grab lat,lng once map is generated
//   getResults( lat, lng );
// });

$('form').on('submit', function (event) {
	event.preventDefault();
	var cuisine = $(this).find('select').val()
	var price = $(this).find('input[name="price"]:checked').val()
	var reservation = $(this).find('input[name="reservation"]:checked').val()
	var lat = center.k
	var lng = center.B

	getResults(lat, lng, cuisine, price, reservation)
})

// $('#search').on('submit', function (event) {
// 	event.preventDefault();
// 	debugger
// })


searchForFriends();


console.log('search loaded')

}