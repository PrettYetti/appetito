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

```javascript
//friend searching functionality on the user's profile page
var searchForFriends = function () {
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

          data.users.forEach(function (user) {
            user.type = "person";
            if (data.current_user_id == user.id) {
              data.users.splice(data.users.indexOf(user), 1)
            }
            data.friends.forEach(function (friend) {
              if (friend.id == user.id) {
                user.type = "friend";
              }
            })
          })

          // console.log(data)
          $("#newfriend-list").children().remove();
          data.users.forEach( function( user ) {
            var $addFriend = $('<li>').text(user["name"]);
            if (user.type === "friend") {
              var $addFriendButton = $('<button>', {class: "btn btn-default btn-sm"}).text("Friends");
            } else {  
              var $addFriendButton = $('<button>', {action: user.id+'/add_friend', class: "btn btn-default btn-sm", method: 'POST'}).text("Add Friend");
              friendRequest($addFriendButton);
            }
            $("#newfriend-list").append(($addFriend.append($addFriendButton)))
          });
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
  });  
};

function friendRequest($dom) {
  var that = $dom
  $dom.on('click', function (e) {
    e.preventDefault();
    var action = that.attr('action')
    $.ajax({
      url: action,
      type: 'POST',
      dataType: 'json',
      success: function (data) {
        if (data.privacy) {
          that.text("Request Sent")
        } else { that.text("Friend")}
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
    })
  });
};



```