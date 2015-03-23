window.onload = function () {

console.log("fivesquare loaded")

var pathname = window.location.pathname;
function getResults(lat, lng){
	var baseURL = "https://api.foursquare.com/v2/venues/explore";
	var clientID = "?client_id=CSXMPXYF20VXWMX4Z0BTKHVT5VGRKA1E3ZAPKCE04ELOMX3W";
	var clientSecret = "&client_secret=LQ2UIGEDAP0O5CFMQEMEYEM1KORYH4ISVPXLRSHGYNU1LMOZ";
	var version = "&v=20130815&limit=20";
	var locale = "&ll="+lat+","+lng+"&radius="+window.radius;
	var cuisine = "&section=food";
	var compile = clientID + clientSecret + version + locale + cuisine;
	var map = handler.map.serviceObject;

	function parseVenue (venue) {
		var pricefix = (venue["venue"]["price"] === undefined) ? 0 : venue["venue"]["price"]["tier"]
		return {
			name: venue["venue"]["name"],
			cuisine: venue["venue"]["categories"][0]["shortName"],
			phone: venue["venue"]["contact"]["formattedPhone"],
			address: venue["venue"]["location"]["formattedAddress"].join(", "),
			rating: venue["venue"]["rating"],
			price: pricefix

		}
	}

	function renderResults (data) {
		venues = data["response"]["groups"]["0"]["items"]	

		

		

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
			$('<li>').text(venues.address).appendTo($newUl)
			$('<li>').text("Rating: " + venues.rating).appendTo($newUl);
			$('<li>').text("Price: " + Array(venues.price+1).join("$")).appendTo($newUl);

			$newUl.appendTo($('#results'));
		}
		var $results = $('#results');
		$results.html('');

		$(venues).each(function(index, venue) {
			makeVenue(parseVenue(venue), index)
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
			})
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
							var $name = $('<li></li>').append($('<h4>').text(data.name));
							var $cuisine = $('<li></li>').text(data.cuisine);
							var $price = $('<li></li>').text(Array(data.price+1).join("$"));
							var $rating = $('<li></li>').text(data.rating);
							var $confirmFavorite = $('<span id="confirm" aria-hidden="true" class="glyphicon glyphicon-ok"></span>')
							var $voteFavorite = $('<span aria-hidden="true" class="glyphicon glyphicon-heart favorite"></span>')

							var $newFavoriteUl = $('<ul>', {id: data.id}).append($name, $cuisine, $price, $rating, $confirmFavorite, $voteFavorite)
							var $newFavoriteLi = $('<li>', {id: data.id, class: "col-xs-6 col-sm-3"}).append($newFavoriteUl)
							$('#favorite-wrapper').append($newFavoriteLi)
							toggleFavorite($voteFavorite)
							console.log('trying to add stuff')
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
			dataType: '',
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

toggleFavorite($('.favorite'))
toggleFavorite($('.favorited'))

$('.fs').on('click', function(event){

  event.preventDefault();
  var searchDegree = 1000
  var lat = center.k
  var lng = center.B
  console.log(lat,lng)


  //fix this to grab lat,lng once map is generated
  getResults( lat, lng );
});

// $('form').on('submit', function (event) {
// 	event.preventDefault();
// 	var cuisine = $(this).find('select').val()
// 	var price = $(this).find('input[name="price"]:checked').val()
// 	var reservation = $(this).find('input[name="reservation"]:checked').val()



// })

// $('#search').on('submit', function (event) {
// 	event.preventDefault();
// 	debugger
// })


searchForFriends();


console.log('search loaded')

}