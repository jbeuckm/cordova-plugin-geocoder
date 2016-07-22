#import "CDVGeocoder.h"

@implementation CDVGeocoder

- (CDVPlugin*)initWithWebView:(UIWebView*)theWebView
{
    [self pluginInitialize];

    return self;
}


- (void)geocodeString:(CDVInvokedUrlCommand*)command
{
    NSString* callbackId = command.callbackId;
    NSString* addressString = [command.arguments objectAtIndex:0];
    
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [self.commandDelegate runInBackground:^{ //avoid main thread block  especially if sharing big files from url

    
        [geocoder geocodeAddressString:addressString completionHandler:^(NSArray *placemarks, NSError *error) {
            if (error)
            {
                NSLog(@"Geocode failed with error: %@", error);

                CDVPluginResult* result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:error.localizedDescription];
                [self.commandDelegate sendPluginResult:result callbackId:callbackId];
            } else {

                NSLog(@"Received placemarks: %@", placemarks);

                CLPlacemark *place = [placemarks objectAtIndex:0];
                NSDictionary *loc = [NSDictionary dictionaryWithObjectsAndKeys:
                                    [NSNumber numberWithDouble:place.location.coordinate.latitude], @"latitude",
                                    [NSNumber numberWithDouble:place.location.coordinate.longitude ], @"longitude", nil];
            
                CDVPluginResult* result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:loc];
                [self.commandDelegate sendPluginResult:result callbackId:callbackId];
            }
        
        }];
    }];
     
}


- (void)dealloc
{

}

- (void)onReset
{

}

@end
