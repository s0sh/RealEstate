//
//  SearchResultsViewController.h
//  RealEstate
//
//  Created by macmini7 on 10/06/14.
//  Copyright (c) 2014 macmini7. All rights reserved.
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
