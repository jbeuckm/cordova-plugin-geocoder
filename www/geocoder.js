
var argscheck = require('cordova/argscheck'),
    utils = require('cordova/utils'),
    exec = require('cordova/exec');
    
var geocoder = {
    /**
     * Forward geocodes a string.
     *
     * @param {String} _string       The address string to be geocoded
     */
    geocodeString: function(successCallback, errorCallback, addressString) {
        exec(successCallback, errorCallback, "Geocoder", "geocodeString", [addressString]);
    }
};

module.exports = geocoder;
