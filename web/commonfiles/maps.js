function initialize() {
              var mapProp = {
                center:new google.maps.LatLng(15.3935685,75.08009570000002),
                zoom:15,
                mapTypeId:google.maps.MapTypeId.ROADMAP
              };
              var map=new google.maps.Map(document.getElementById("googleMap"),mapProp);
              var ctaLayer = new google.maps.KmlLayer({
                url: 'http://hack4hd.org/data/HD-ward-boundaries.kml',
                map: map
              });

            }
            google.maps.event.addDomListener(window, 'load', initialize);
           
            