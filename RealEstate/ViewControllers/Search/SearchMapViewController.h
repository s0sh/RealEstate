//
//  SearchMapViewController.h
//  RealEstate
//
//  Created by macmini7 on 10/06/14.
//  Copyright (c) 2014 macmini7. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ModelClass.h"
#import <MapKit/MapKit.h>

@interface SearchMapViewController : UIViewController<MKMapViewDelegate,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet MKMapView *mapPropperties;
@property (weak, nonatomic) IBOutlet UITextField *txtSearch;
@property(strong)ModelClass *mc;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
- (IBAction)btnBackClicked:(id)sender;
- (IBAction)viewListClicked:(id)sender;
- (IBAction)searchClicked:(id)sender;
- (IBAction)listClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *btnRefine;
@property (weak, nonatomic) IBOutlet UIButton *btnList;
@end
