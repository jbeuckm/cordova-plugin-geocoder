package org.beuckman.geocoder;

import org.apache.cordova.CordovaPlugin;
import org.apache.cordova.CallbackContext;
import org.apache.cordova.CordovaWebView;
import org.apache.cordova.CordovaInterface;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;
import java.util.List;

import android.location.Geocoder;
import android.location.Address;

/**
 * This class echoes a string called from JavaScript.
 */
public class CDVGeocoder extends CordovaPlugin {
    
    Geocoder geocoder;

    @Override
	public void initialize(CordovaInterface cordova, CordovaWebView webView) {
        super.initialize(cordova, webView);
                System.out.print("CDVGeocoder initialize");
	}

    @Override
    public boolean execute(String action, JSONArray args, CallbackContext callbackContext) throws JSONException {
        
        if (action.equals("geocodeString")) {
            String addressString = args.getString(0);
            this.geocodeString(addressString, callbackContext);
            return true;
        }

        return false;
        
    }

    private void geocodeString(String addressString, CallbackContext callbackContext) {

        geocoder = new Geocoder(cordova.getActivity().getApplicationContext());

        if (addressString != null && addressString.length() > 0) {

            try {
                List<Address> geoResults = geocoder.getFromLocationName(addressString, 1);
                while (geoResults.size()==0) {
                    geoResults = geocoder.getFromLocationName(addressString, 1);
                }
                if (geoResults.size()>0) {
                    Address addr = geoResults.get(0);
                    System.out.print(addr);
                    
                    JSONObject coords = new JSONObject();
                    coords.put("latitude", addr.getLatitude());
                    coords.put("longitude", addr.getLongitude());

                    System.out.print(coords);
                    callbackContext.success(coords);
                }
            
            } catch (Exception e) {
                System.out.print(e.getMessage());
                callbackContext.error(e.getMessage());
            }
            
        } else {
            callbackContext.error("Expected one non-empty string argument.");
        }
    }
    
}