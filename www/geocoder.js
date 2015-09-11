
var argscheck = require('cordova/argscheck'),
    utils = require('cordova/utils'),
    exec = require('cordova/exec');
    
var Geocoder = {
    /**
     * Forward geocodes a string.
     *
     * @param {String} _addessString       The address string to be geocoded
     * @param {Int}    _nbMaxResults       [OPTIONAL] The maximum nb of results
     */
    geocodeString: function(successCallback, errorCallback, addressString, nbMaxResults) {
		nbMaxResults = nbMaxResults || '1'; // optional parameter which defaults to '1'
        exec(successCallback, errorCallback, "Geocoder", "geocodeString", [addressString, nbMaxResults]);
    }
    
};

module.exports = Geocoder;
