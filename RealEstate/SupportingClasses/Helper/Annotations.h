//
//  Annotations.h
//  MKMapView
//
//  Created by Peerbits Solution on 01/12/12.
//  Copyright (c) 2012 Peerbits Solution. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MapKit/Mapkit.h"
@interface Annotations : NSObject<MKAnnotation>{
    
    
}
@property(nonatomic,assign) CLLocationCoordinate2D coordinate;
@property(nonatomic,copy) NSString *title;
@property(nonatomic,copy) NSString *subtitle;
@property(nonatomic,copy) NSString *place_id;
@property(nonatomic,copy) NSString *facilities;



@end
