window.onload = function () {

console.log("fivesquare loaded")
var pathname = window.location.pathname;
function getResults(lat, lng){
  var baseURL = "https://api.foursquare.com/v2/venues/explore";
  var clientID = "?client_id=CSXMPXYF20VXWMX4Z0BTKHVT5VGRKA1E3ZAPKCE04ELOMX3W";
  var clientSecret = "&client_secret=LQ2UIGEDAP0O5CFMQEMEYEM1KORYH4ISVPXLRSHGYNU1LMOZ";
  var version = "&v=20130815&limit=20";
  var locale = "&ll="+lat+","+lng;
  var cuisine = "&section=food";
  var compile = clientID + clientSecret + version + locale + cuisine;

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
      this.infowindow = venue["venue"]["name"]
      this.lat = venue["venue"]["location"]["lat"]
      this.lng = venue["venue"]["location"]["lng"]
      this.picture = {
        "url" : "http://i.imgur.com/15cYFQt.png",
        "width" : 36,
        "height" :47
      }
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

    var markers = []
    $(venues).each(function(index, venue) {
      makeVenue(parseVenue(venue))
      markers.push(new buildMarker(venue))
    });

    handler.addMarkers(markers).forEach(function(marker){
      window.markers.push(marker)
    })

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
              if ($( "#favorite-container:contains('"+data.favorite.restaurant+"')" )[0] === undefined) {
              $('#favorite-container').find($('ul')).append(
                $('<li></li>', {class: "col-xs-6 col-sm-3"}).append($('<h4>').text(data.favorite.restaurant)));
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
  var lat = handler.map.serviceObject.center.k
  var lng = handler.map.serviceObject.center.B

  getResults( lat, lng );
}); 
}