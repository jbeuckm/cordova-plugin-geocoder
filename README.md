
# org.beuckman.geocoder

## Installation

    git clone git@github.com:jbeuckm/cordova-plugin-geocoder.git
    cd myproject
    cordova plugin add ../cordova-plugin-geocoder

## Supported Platforms

- iOS

## Methods

- navigator.geocoder.geocodeString


## navigator.geocoder.geocodeString

Forward geocode a given address to find coordinates.

    navigator.geocoder.geocodeString(addressString);

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

