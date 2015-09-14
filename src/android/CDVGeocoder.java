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
 * This Cordova Plugin class returns a JSON Object
 * or Array containing the geocoded coordinates.
 */
public class CDVGeocoder extends CordovaPlugin {
    Geocoder geocoder;

	private static final int MAX_NB_ITERATIONS = 10;

    @Override
    public void initialize(CordovaInterface cordova, CordovaWebView webView) {
        super.initialize(cordova, webView);
		//System.out.print("CDVGeocoder initialize");

		// we only need to instantiate the geocoder object once.
        geocoder  = new Geocoder(cordova.getActivity().getApplicationContext());
    }

    @Override
    public boolean execute(String action, JSONArray args, CallbackContext callbackContext) throws JSONException {

        if (action.equals("geocodeString")) {
            String addressString = args.getString(0);
			int nbMaxResults = 1;
			if (args.length()>1) {
				// optional parameter, defaults to 1.
				nbMaxResults = args.getInt(1);
			}
            this.geocodeString(addressString, nbMaxResults, callbackContext);
            return true;
        }

        return false;

    }

    private void geocodeString(String addressString, int nbMaxResults, CallbackContext callbackContext) throws JSONException {

        if (addressString != null && addressString.length() > 0) {

            try {
                List<Address> geoResults = geocoder.getFromLocationName(addressString, nbMaxResults);
				/* NOTE :
				 * geocoder.getFromLocationName does not always return results the first
				 * time it is called. So we need to iterate a few times to be sure.
				 * But not too much, which would result in an infinite loop ..
				 */
				int iterations = 0;
                while ((geoResults.size()==0) && (iterations<MAX_NB_ITERATIONS)) {
					iterations++;
                    geoResults = geocoder.getFromLocationName(addressString, 1);
                }

                if (geoResults.size()>0) {
					if (nbMaxResults == 1) {
						callbackContext.success(createJSONAddress(geoResults.get(0)));
					}
					else if (nbMaxResults > 1) {
						JSONArray allAddresses = new JSONArray();
						for (int i=0; i<geoResults.size() && i<nbMaxResults; i++) {
							allAddresses.put(i,createJSONAddress(geoResults.get(i)));
						}
						callbackContext.success(allAddresses);
					}
					else {
						callbackContext.error("invalid nbMaxResults : " + nbMaxResults);
					}
                }
                else{
                    callbackContext.error("no address found !");
                }

            } catch (Exception e) {
                //System.out.print(e.getMessage());
                callbackContext.error(e.getMessage());
            }

        } else {
            callbackContext.error("Expected a non-empty string as first argument.");
        }
    }

	private JSONObject createJSONAddress(Address addr) throws JSONException {
		//System.out.print(addr);

		JSONObject coords = new JSONObject();

		coords.put("latitude", addr.getLatitude());
		coords.put("longitude", addr.getLongitude());
		coords.put("address", addr.getAddressLine(0) +" "+ addr.getAddressLine(1)+" "+addr.getAddressLine(2));

		//System.out.print(coords);

		return coords;
	}
}