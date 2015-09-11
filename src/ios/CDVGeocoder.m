#import "CDVGeocoder.h"

#define FIRST_ADDRESS 0

@implementation CDVGeocoder

- (CDVPlugin*)initWithWebView:(UIWebView*)theWebView
{
    self = (CDVGeocoder*)[super initWithWebView:(UIWebView*)theWebView];

    return self;
}


- (void)geocodeString:(CDVInvokedUrlCommand*)command withParameters:(NSInteger)aParameter
{
    NSString* callbackId = command.callbackId;
    NSString* addressString = [command.arguments objectAtIndex:0];
    
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    
    [geocoder geocodeAddressString:addressString completionHandler:^(NSArray *placemarks, NSError *error) {
        if (error) {
            NSLog(@"Geocode failed with error: %@", error);
            
            CDVPluginResult* result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:error.localizedDescription];
            [self.commandDelegate sendPluginResult:result callbackId:callbackId];
        } else {
            
            NSLog(@"Received placemarks: %@", placemarks);
            
            if (aParameter == FIRST_ADDRESS) {
                CLPlacemark *place = [placemarks objectAtIndex:FIRST_ADDRESS];
                
                NSDictionary *loc = [self locationDictionaryFromPlaceMark:place];
                
                CDVPluginResult* result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:loc];
                [self.commandDelegate sendPluginResult:result callbackId:callbackId];
            }
            else {
                NSMutableArray *locations = [NSMutableArray array];
                for (NSUInteger i = 0; i < [placemarks count]; i++) {
                    CLPlacemark *place = [placemarks objectAtIndex:i];
                    
                    NSDictionary *loc = [self locationDictionaryFromPlaceMark:place];
                    
                    [locations addObject:loc];
                }
                
                CDVPluginResult* result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:loc];
                [self.commandDelegate sendPluginResult:result callbackId:callbackId];
            }
        }
        
    }];
}

- (NSDictionary *)locationDictionaryFromPlaceMark:(CLPlacemark *)aPlace {
    NSDictionary *loc = [NSDictionary dictionaryWithObjectsAndKeys:
                         [NSNumber numberWithDouble:aPlace.location.coordinate.latitude], @"latitude",
                         [NSNumber numberWithDouble:aPlace.location.coordinate.longitude ], @"longitude", nil];
    return loc;
}

- (void)dealloc
{

}

- (void)onReset
{

}

@end
