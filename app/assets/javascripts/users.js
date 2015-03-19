var searchForFriends = function () {$('.search').find($('input')).on('keyup', function (event) {
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
}