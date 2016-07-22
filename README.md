
# org.beuckman.geocoder

## Installation

    cordova plugin add https://github.com/jbeuckm/cordova-plugin-geocoder.git

## Supported Platforms

- iOS
- Android

## Methods

- navigator.geocoder.geocodeString


## navigator.geocoder.geocodeString

Forward geocode a given address to find coordinates.

    navigator.geocoder.geocodeString(successCallback, errorCallback, addressString);

### Parameters

- __addressString__: The address to be geocoded. (String)

### Example

    function onError(err) {
        alert(JSON.stringify(err));
    }
    function onSuccess(coords) {
        alert("The location is lat="+coords.latitude+", lon="+coords.longitude);
    }

    navigator.geocoder.geocodeString(onSuccess, onError, "55418");

