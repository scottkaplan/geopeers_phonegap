// Your app must execute AT LEAST ONE call for the current position via standard Cordova geolocation,
//  in order to prompt the user for Location permission.
window.navigator.geolocation.getCurrentPosition(function(location) {
        console.log('Location from Phonegap');
    });

var bgGeo;

function ajax_request (request_parms, success_callback, failure_callback) {
    // phonegap runs from https://geopeers.com
    // we now allow xdomain from that URL
    var url = "https://eng.geopeers.com/api";
    $.ajax({type:  "POST",
	    async: true,
	    url:   url,
	    data:  request_parms,
	  })
	.done(success_callback)
	.fail(failure_callback);
    return;
}

/**
 * This callback will be executed every time a geolocation is recorded in the background.
 */
var callbackFn = function(location) {
    console.log('[js] BackgroundGeoLocation callback:  ' + location.latitude + ',' + location.longitude);
    console.log (this);
    // IMPORTANT:  You must execute the #finish method here to inform the native plugin that you're finished,
    //  and the background-task may be completed.  You must do this regardless if your HTTP request is successful or not.
    // IF YOU DON'T, ios will CRASH YOUR APP for spending too much time in the background.
    //
    //
    bgGeo.finish();

    // Do your HTTP request here to POST location to your server.
    //
    //
    var request_parms = { gps_longitude: location.longitude,
			  gps_latitude:  location.latitude,
			  method:        'send_position',
			  device_id:     'DEV_42',
    };
    ajax_request (request_parms);

};

var failureFn = function(error) {
    console.log('BackgroundGeoLocation error'.error.inspect);
};

function init_background_gps () {
    bgGeo = window.plugins.backgroundGeoLocation;
    bgGeo.configure(callbackFn, failureFn, {
	    // Android only
	    url: 'http://eng.geopeers.com/api',
	    params: {
		method:    'send_position',
		device_id: device_id_mgr.get(),
	    },
	    notificationTitle: 'Background tracking', // customize the title of the notification
	    notificationText: 'ENABLED',              // customize the text of the notification

	    desiredAccuracy: 10,
	    stationaryRadius: 20,
	    distanceFilter: 30, 
	    activityType: 'AutomotiveNavigation',
	    debug: true // <-- enable this hear sounds for background-geolocation life-cycle.
	});

    // Turn ON the background-geolocation system.  The user will be tracked whenever they suspend the app.
    bgGeo.start();

    // If you wish to turn OFF background-tracking, call the #stop method.
    // bgGeo.stop();
}

document.addEventListener("deviceready", init_background_gps, false);
