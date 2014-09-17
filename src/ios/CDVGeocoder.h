#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <Cordova/CDVPlugin.h>


@interface CDVGeocoder : CDVPlugin {

}

- (void)geocodeString:(CDVInvokedUrlCommand*)command;

@end
