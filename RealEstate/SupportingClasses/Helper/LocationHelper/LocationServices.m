//
//  LocationServices.m
//  FDM
//
//  Created by BSN on 9/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "LocationServices.h"


LocationServices * gLocationServices = nil;
@implementation LocationServices
@synthesize latitude, longitude, locationManager;
+ (void) initializeService
{
    gLocationServices = [[LocationServices alloc] init];
}

- (id) init
{
    self = [super init];
    if(self)
    {
        locationManager = [[CLLocationManager alloc] init];
        locationManager.delegate = self;
        locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        locationManager.distanceFilter = kCLLocationAccuracyHundredMeters;
        
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0 &&
            [CLLocationManager authorizationStatus] != kCLAuthorizationStatusAuthorizedWhenInUse
            //[CLLocationManager authorizationStatus] != kCLAuthorizationStatusAuthorizedAlways
            )
        {
            
            [locationManager requestWhenInUseAuthorization];
            [locationManager startUpdatingLocation];
            
        } else {
             [locationManager requestAlwaysAuthorization];
            [locationManager startUpdatingLocation]; //Will update location immediately
        }

    }
    return self;
}
#pragma mark - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager*)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    switch (status) {
        case kCLAuthorizationStatusNotDetermined: {
            NSLog(@"User still thinking..");
        } break;
        case kCLAuthorizationStatusDenied: {
            NSLog(@"User hates you");
        } break;
        case kCLAuthorizationStatusAuthorizedWhenInUse:
        case kCLAuthorizationStatusAuthorizedAlways: {
            [locationManager startUpdatingLocation]; //Will update location immediately
        } break;
        default:
            break;
    }
}
// Called when there is an error getting the location
- (void)locationManager:(CLLocationManager *)manager
	   didFailWithError:(NSError *)error
{
	NSMutableString *errorString = [[NSMutableString alloc] init];
	
	if ([error domain] == kCLErrorDomain) {
		
		// We handle CoreLocation-related errors here
		
		switch ([error code]) {
				// This error code is usually returned whenever user taps "Don't Allow" in response to
				// being told your app wants to access the current location. Once this happens, you cannot
				// attempt to get the location again until the app has quit and relaunched.
				//
				// "Don't Allow" on two successive app launches is the same as saying "never allow". The user
				// can reset this for all apps by going to Settings > General > Reset > Reset Location Warnings.
				//
			case kCLErrorDenied:
				[errorString appendFormat:@"%@\n", NSLocalizedString(@"LocationDenied", nil)];
				break;
				
				// This error code is usually returned whenever the device has no data or WiFi connectivity,
				// or when the location cannot be determined for some other reason.
				//
				// CoreLocation will keep trying, so you can keep waiting, or prompt the user.
				//
			case kCLErrorLocationUnknown:
				[errorString appendFormat:@"%@\n", NSLocalizedString(@"LocationUnknown", nil)];
				break;
				
				// We shouldn't ever get an unknown error code, but just in case...
				//
			default:
				[errorString appendFormat:@"%@ %d\n", NSLocalizedString(@"GenericLocationError", nil), [error code]];
				break;
		}
	} else {
		// We handle all non-CoreLocation errors here
		// (we depend on localizedDescription for localization)
		[errorString appendFormat:@"Error domain: \"%@\"  Error code: %d\n", [error domain], [error code]];
		[errorString appendFormat:@"Description: \"%@\"\n", [error localizedDescription]];
	}
	
	// Send the update to our delegate
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}
// Called when the location is updated
- (void)locationManager:(CLLocationManager *)manager
	didUpdateToLocation:(CLLocation *)newLocation
		   fromLocation:(CLLocation *)oldLocation
{	
    self.latitude = newLocation.coordinate.latitude;
    self.longitude = newLocation.coordinate.longitude;
    
}
- (void) startUpdateLocation
{
    [LocationServices cancelPreviousPerformRequestsWithTarget:self selector:@selector(startUpdateLocation) object:nil];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    [locationManager startUpdatingLocation];
}
- (void) stopUpdateLocation
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    [locationManager stopUpdatingLocation];
    [LocationServices cancelPreviousPerformRequestsWithTarget:self selector:@selector(startUpdateLocation) object:nil];
    [self performSelector:@selector(startUpdateLocation) withObject:nil afterDelay:5*60];
}

@end
