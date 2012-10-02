function initialise_map() {
    var myLatLng = new google.maps.LatLng(53.257725,-2.122331);

    var myOptions = {
        center: myLatLng,
        zoom: 16,
        mapTypeId: google.maps.MapTypeId.ROADMAP
    };

    var map = new google.maps.Map(
        document.getElementById("map_canvas"),
        myOptions
    );

    setTimeout(
        function () {
            var marker = new google.maps.Marker({
                position: myLatLng,
                title: 'Inca Café Bar',
                map: map,
                animation: google.maps.Animation.DROP
            });
        },
        1500
    );


}
