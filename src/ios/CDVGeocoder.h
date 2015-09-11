#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <Cordova/CDVPlugin.h>


@interface CDVGeocoder : CDVPlugin {}

- (void)geocodeString:(CDVInvokedUrlCommand*)command;

@end
