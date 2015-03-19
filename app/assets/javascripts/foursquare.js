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


	function renderResults (data) {
		var venues = data["response"]["groups"]["0"]["items"]		

		

		function parseVenue (venue) {
			var pricefix = (venue["venue"]["price"] === undefined) ? 0 : venue["venue"]["price"]["tier"]
			return {
				name: venue["venue"]["name"],
				phone: venue["venue"]["contact"]["formattedPhone"],
				address: venue["venue"]["location"]["formattedAddress"],
				rating: venue["venue"]["rating"],
				price: pricefix

			}
		}

		function buildMarker (venue) {
			this.name = venue["venue"]["name"]
			this.lat = venue["venue"]["location"]["lat"]
			this.lng = venue["venue"]["location"]["lng"]
			this.picture = "http://i.imgur.com/15cYFQt.png"
		}

		function makeVenue (venues) {
			var $newUl = $('<ul>').after($('<br>'));
			$('<li>').append($('<h2>').text(venues.name)).append($('<button>', {action: pathname+'/add_favorite', class: "favorite"}).text("Add me to favorites")).appendTo($newUl);
			$('<li>').text(venues.phone).appendTo($newUl);
			$('<li>').text(venues.address.join(", ")).appendTo($newUl)
			$('<li>').text("Rating: " + venues.rating).appendTo($newUl);
			$('<li>').text("Price: " + Array(venues.price+1).join("$")).appendTo($newUl);

			$newUl.appendTo($('#results'));
		}
		var $results = $('#results');
		$results.html('');

		$(venues).each(function(index, venue) {
			makeVenue(parseVenue(venue))
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
			window.markers.push(marker)
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
			renderResults(data);
			$('ul').find($('button')).on('click', function (event) {
				event.preventDefault();
				var name = $(this).parent().find($('h2')).text();
				$.ajax({
					url: pathname+'/add_favorite',
					type: 'POST',
					dataType: 'json',
					data: {restaurant: name},
					success: function(data){
							if ($( ".favorites:contains('"+data.favorite.restaurant+"')" )[0] === undefined) {
							$('.favorites').find($('ul')).append($('<li>').text(data.favorite.restaurant))
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



$('.fs').on('click', function(event){

  event.preventDefault();
  var searchDegree = 1000
  var lat = Math.round(handler.map.serviceObject.center.k*searchDegree)/searchDegree
  var lng = Math.round(handler.map.serviceObject.center.B*searchDegree)/searchDegree
  console.log(lat,lng)


  //fix this to grab lat,lng once map is generated
  getResults( lat, lng );
});	

$('.search').find($('input')).on('keyup', function (event) {
	var input = $(this).val()
	if ( input.length > 0) {
		$.ajax({
			url: '/users',
			type: 'GET',
			dataType: 'json',
			data: {search: input},
			success: function (data) {
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
	}
	
})


$('.search').on('submit', function (event) { 
	event.preventDefault();
	console.log("searching?");			
		
		
	})

console.log('search loaded')

}