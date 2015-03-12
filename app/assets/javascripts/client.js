window.addEventListener("load", function() {
  var client = new WebSocket("ws://localhost:2000");

  //listen for opening of client connection
  client.addEventListener("open", function(evt) {
    console.log("you are connected!");

    //grab html elements
    var chatwindow = document.getElementById("chatwindow");
    var userInput = document.getElementById("textbox");
    var submit = document.getElementById("submitchat");

    //listen for messages from the server
    client.addEventListener("message", function(msg) {
      var serverMessage = JSON.parse(msg.data);
      var newMessage = document.createElement("p");
      newMessage.innerHTML = serverMessage;
      chatwindow.appendChild(newMessage);

    });

    //listen for input from user (submit button click)
    submit.addEventListener("click", function() {
      var clientMessage = userInput.value;
      client.send(JSON.stringify(clientMessage));
      userInput.value = "";
    });

    //listen for input from user (enter keypress)
    userInput.addEventListener("keydown", function(press) {
      if (press.keyCode === 13) {
        submit.click();
      }
    });

  });
});
