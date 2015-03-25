//JAVASCRIPT FOR DISPLAY AND HIDE ELEMENTS 'ON CLICK' ON EVENTS PAGE 
$(function(){
    $("#event-subnav").on("click", ".subnav-button", function(e)
        {   
            setTimeout(function() {
            google.maps.event.trigger(map, "resize");
            bounds = new google.maps.LatLngBounds();
            markers.forEach(function (marker) {
                var myLatlng = new google.maps.LatLng(marker.Kf.Ca.k, marker.Kf.Ca.B);
                bounds.extend(myLatlng);
            })
            handler.map.serviceObject.fitBounds(calibrate(bounds));
            }, 1);
            var $button = $(this)
            var $target = $($button.data("target"));
            $target.removeClass("hidden");
            $target.siblings().addClass("hidden");
            var $chatwindow = $("#chatwindow");
            $chatwindow[0].scrollTop = $chatwindow[0].scrollHeight;
    });

    $('.rsvps').on('click', function (event) {
        var id = $(this).parent().parent()[0].id
        var rsvpTag = this.children[0]
        var pathname = window.location.pathname
        if (rsvpTag.classList.contains("glyphicon-ok")){
            rsvp = "Attending"
        } else if (rsvpTag.classList.contains("glyphicon-remove")) {
            rsvp = "Not Attending"
        } else { rsvp = "Maybe"}

        $.ajax({
            url: "/invites/"+id,
            type: 'put',
            dataType: 'json',
            data: {invite: {rsvp: rsvp}},
            success: function(data) {
                console.log(data)
                //class change goes here.
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
        
    });


    $("#add-location").on("submit", function(e){
        e.preventDefault();
        // markers.forEach( function (marker) )
        var input  = $('#add-location').find('input:text').val()
        var form = this
        $.ajax({
            url: $('#add-location')[0].action,
            type: 'PUT',
            dataType: 'json',
            data: {invite: {location: input}},
            success: function (data) {
                markers.forEach( function (marker) {
                    marker.setMap(null);
                })
                searchMarkers.forEach( function (marker) {
                    marker.setMap(null);
                })
                markers = []
                searchMarkers = []
                bounds = new google.maps.LatLngBounds()
                data.forEach( function (invitee) {
                    buildMarker(invitee)
                    setRadius(invitee.lat, invitee.lng)
                })
                map.fitBounds(calibrate(bounds));
                center = map.center
                window.radius = measure (maxlat, maxlng, minlat, minlng)/1.5
                console.log(radius)
                form.reset();
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

});

//JAVASCRIPT FOR CHAT WINDOW STYLING
$(document).on('click', '.panel-heading span.icon_minim', function (e) {
    var $this = $(this);
    if (!$this.hasClass('panel-collapsed')) {
        $this.parents('.panel').find('.panel-body').slideUp();
        $this.addClass('panel-collapsed');
        $this.removeClass('glyphicon-minus').addClass('glyphicon-plus');
    } else {
        $this.parents('.panel').find('.panel-body').slideDown();
        $this.removeClass('panel-collapsed');
        $this.removeClass('glyphicon-plus').addClass('glyphicon-minus');
    }
});
$(document).on('focus', '.panel-footer input.chat_input', function (e) {
    var $this = $(this);
    if ($('#minim_chat_window').hasClass('panel-collapsed')) {
        $this.parents('.panel').find('.panel-body').slideDown();
        $('#minim_chat_window').removeClass('panel-collapsed');
        $('#minim_chat_window').removeClass('glyphicon-plus').addClass('glyphicon-minus');
    }   
});
$(document).on('click', '#new_chat', function (e) {
    var size = $( ".chat-window:last-child" ).css("margin-left");
     size_total = parseInt(size) + 400;
    alert(size_total);
    var clone = $( "#chat_window_1" ).clone().appendTo( ".container" );
    clone.css("margin-left", size_total);
});
$(document).on('click', '.icon_close', function (e) {
    //$(this).parent().parent().parent().parent().remove();
    $( "#chat_window_1" ).remove();
});

