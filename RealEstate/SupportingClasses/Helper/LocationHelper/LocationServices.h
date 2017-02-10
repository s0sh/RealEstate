//
//  LocationServices.h
//  FDM
//
//  Created by BSN on 9/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
@interface LocationServices : NSObject<CLLocationManagerDelegate>
{
    
}

@property (nonatomic, strong) CLLocationManager * locationManager;
@property (nonatomic) double latitude;
@property (nonatomic) double longitude;
+ (void) initializeService;
- (void) startUpdateLocation;
- (void) stopUpdateLocation;

@end

extern LocationServices * gLocationServices;