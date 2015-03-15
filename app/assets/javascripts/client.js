jQuery(function() {
  var client = new WebSocket("ws://localhost:2000");

  //listen for opening of client connection
  client.addEventListener("open", function(evt) {
    console.log("you are connected!");

    //grab html elements
    var $chatwindow = $("#chatwindow");
    var $userInput = $("#textbox")[0];
    var $submit = $("#submitchat")[0];

    //listen for messages from the server
    client.addEventListener("message", function(msg) {
      var $serverMessage = JSON.parse(msg.data);
      var $messageDiv = $("<div></div>", {class: "messages"});
      $messageDiv.append($("<p>").text($serverMessage));
      var dt = new Date();
      var timeNow = dt.getHours() + ":" + dt.getMinutes() + ":" + dt.getSeconds();
      $messageDiv.append($("<time>").text(timeNow));
      $colDiv = $("<div></div>", {class: "col-md-10 col-xs-10"});
      $chatwindow.append($messageDiv);
    });

    //listen for input from user (submit button click)
    $submit.addEventListener("click", function() {
      var $clientMessage = $userInput.value;
      client.send(JSON.stringify($clientMessage));
      $userInput.value = "";
    });

    //listen for input from user (enter keypress)
    $userInput.addEventListener("keydown", function(press) {
      if (press.keyCode === 13) {
        $submit.click();
      }
    });

  });
});
