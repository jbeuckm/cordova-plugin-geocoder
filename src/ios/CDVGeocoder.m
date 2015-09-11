#import "CDVGeocoder.h"

@implementation CDVGeocoder

- (CDVPlugin*)initWithWebView:(UIWebView*)theWebView
{
    self = (CDVGeocoder*)[super initWithWebView:(UIWebView*)theWebView];

    return self;
}


- (void)geocodeString:(CDVInvokedUrlCommand*)command
{
    NSString* callbackId = command.callbackId;
    NSString* addressString = [command.arguments objectAtIndex:0];
    NSString* nbMaxResultString = @"1";
    if (command.arguments.count > 1) {
        nbMaxResultString = [command.arguments objectAtIndex:1];
    }
    NSInteger nbMaxResult = [nbMaxResultString integerValue];
    
    
    // NOTE : we use MapKit research instead of CoreLocation geocoder geocodeWithAddressString because we want multiple results and the later only returns 1 result.
    MKLocalSearchRequest* request = [[MKLocalSearchRequest alloc] init];
    request.naturalLanguageQuery = addressString;
    //request.region = MKCoordinateRegionMakeWithDistance(loc, kSearchMapBoundingBoxDistanceInMetres, kSearchMapBoundingBoxDistanceInMetres);
    
    MKLocalSearch* search = [[MKLocalSearch alloc] initWithRequest:request];
    [search startWithCompletionHandler:^(MKLocalSearchResponse *response, NSError *error) {

        
        if (error) {
            NSLog(@"Geocode failed with error: %@", error);
            
            CDVPluginResult* result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:error.localizedDescription];
            [self.commandDelegate sendPluginResult:result callbackId:callbackId];
        } else {
            NSLog(@"Received placemarks: %@", response.mapItems);
            
            if (response.mapItems.count > 0) {
                if (nbMaxResult == 1) {
                    MKPlacemark *place = [[response.mapItems objectAtIndex:0] placemark];
                    
                    NSDictionary *loc = [self locationDictionaryFromPlaceMark:place];
                    
                    CDVPluginResult* result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:loc];
                    [self.commandDelegate sendPluginResult:result callbackId:callbackId];
                }
                else if (nbMaxResult > 1) {
                    NSMutableArray *locations = [NSMutableArray array];
                    for (NSInteger i = 0; i < [response.mapItems count] && i < nbMaxResult; i++) {
                        MKMapItem *mapItem = [response.mapItems objectAtIndex:i];
                        MKPlacemark *place = mapItem.placemark;
                        
                        NSDictionary *loc = [self locationDictionaryFromPlaceMark:place];
                        
                        [locations addObject:loc];
                    }
                    
                    CDVPluginResult* result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsArray:locations];
                    [self.commandDelegate sendPluginResult:result callbackId:callbackId];
                }
                else {
                    CDVPluginResult* result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:[NSString stringWithFormat:@"Invalid nb max result : %@", nbMaxResultString]];
                    [self.commandDelegate sendPluginResult:result callbackId:callbackId];
                }
            }
            else {
                CDVPluginResult* result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"no address found !"];
                [self.commandDelegate sendPluginResult:result callbackId:callbackId];
            }
        }
    }];
}

- (NSDictionary *)locationDictionaryFromPlaceMark:(MKPlacemark *)aPlace {
    NSString *addressString = [[aPlace.addressDictionary objectForKey:@"FormattedAddressLines"] componentsJoinedByString:@", "];
    
    NSDictionary *loc = [NSDictionary dictionaryWithObjectsAndKeys:
                         [NSNumber numberWithDouble:aPlace.location.coordinate.latitude], @"latitude",
                         [NSNumber numberWithDouble:aPlace.location.coordinate.longitude ], @"longitude",
                         addressString, @"address", nil];
    return loc;
}

- (void)dealloc
{

}

- (void)onReset
{

}

@end
