
# org.beuckman.geocoder

## Installation

    git clone git@github.com:jbeuckm/cordova-plugin-geocoder.git
    cd myproject
    cordova plugin add ../cordova-plugin-geocoder

## Supported Platforms

- iOS (via MapKit)
- Android (via Android Location)

## Methods

- navigator.geocoder.geocodeString

## navigator.geocoder.geocodeString

To Forward geocode a given address to find coordinates.

    navigator.geocoder.geocodeString(successCallback, errorCallback, addressString);

### Parameters

- __addressString__: The address to be geocoded. (String)
- __nbMaxResults__: The maximum number of addresses to be returned. (OPTIONAL, defaults to 1) (Int)

### Example

    function onError(err) {
        alert(JSON.stringify(err));
    }
    function onSuccess(coords) {
        alert("The location is lat="+coords.latitude+", lon="+coords.longitude);
    }

    navigator.geocoder.geocodeString(onSuccess, onError, "55418");

## navigator.geocoder.geocodeString, with more than one result

To forward geocode a given address with multiple results.

    navigator.geocoder.geocodeString(successCallback, errorCallback, addressString , nbMaxResults);

### Example

    function onError(err) {
        alert(JSON.stringify(err));
    }
    function onSuccess(coords) {
        for (var i = 0; i<2; i++) {
            alert("The location is lat=" + coords[i].latitude + ", lon=" + coords[i].longitude + ", address=" + coords[i].address);
        }
    }

    navigator.geocoder.geocodeAllString(onSuccess, onError, "rue de paris", 2);

