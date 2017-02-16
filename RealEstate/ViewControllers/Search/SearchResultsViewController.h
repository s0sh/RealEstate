//
//  SearchResultsViewController.h
//  RealEstate
//
//  Created by Roman Bigun on 10/06/14.
//  Copyright (c) 2014 Roman Bigun All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "ModelClass.h"

@interface SearchResultsViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet MKMapView *mapPropperties;
@property (retain, nonatomic) NSMutableDictionary *properties;
@property (weak, nonatomic) IBOutlet UIButton *btnSearch;
@property(strong)ModelClass *mc;
@end
