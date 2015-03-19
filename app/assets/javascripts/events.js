//JAVASCRIPT FOR DISPLAY AND HIDE ELEMENTS 'ON CLICK' ON EVENTS PAGE 


$(function(){
    $("#add-location").on("submit", function(e){
        e.preventDefault();
        markers.forEach( function (marker) {
            debugger
            if (marker.infowindow.content.indexOf(current_user.name) >= 0) {
                marker.setMap(null);
            }
        })
    })

    $("#event-subnav").on("click", "button", function(e)
        {   
            setTimeout(function() {
            google.maps.event.trigger(map.serviceObject, "resize");
            var bounds = new google.maps.LatLngBounds();
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
    });
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

