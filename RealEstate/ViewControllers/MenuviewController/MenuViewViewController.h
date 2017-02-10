//
//  MenuViewViewController.h
//  RealEstate
//
//  Created by macmini7 on 09/06/14.
//  Copyright (c) 2014 macmini7. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddPropertyViewController.h"
#import "FacebookviewController.h"

@interface MenuViewViewController : UIViewController<UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *lblUserName;
@property (weak, nonatomic) IBOutlet UIView *viewPropic;
@property (weak, nonatomic) IBOutlet UIImageView *imgViewUserPic;
@property (weak, nonatomic) IBOutlet UIButton *button_mylisting;
@property (weak, nonatomic) IBOutlet UIButton *button_home;
@property (weak, nonatomic) IBOutlet UIButton *button_addProperty;
@property (weak, nonatomic) IBOutlet UIButton *button_contact_us;
@property (weak, nonatomic) IBOutlet UIButton *button_login;
@property (weak, nonatomic) IBOutlet UILabel *lblEditProfile;
@property (weak, nonatomic) IBOutlet UIButton *btnEditProfile;
@property (weak, nonatomic) IBOutlet UIView *container;
@property (weak, nonatomic) IBOutlet UILabel *lblHello;
@property (weak, nonatomic) IBOutlet UIButton *btnSettings;

@property (weak, nonatomic) IBOutlet UIImageView *arrowEn1;
@property (weak, nonatomic) IBOutlet UIImageView *arrowEn2;
@property (weak, nonatomic) IBOutlet UIImageView *arrowEn3;
@property (weak, nonatomic) IBOutlet UIImageView *arrowEn4;
@property (weak, nonatomic) IBOutlet UIImageView *arrowEn5;
@property (weak, nonatomic) IBOutlet UIImageView *arrowEn6;
@property (weak, nonatomic) IBOutlet UIImageView *arrowEn7;


@property (weak, nonatomic) IBOutlet UIImageView *arrowAr1;
@property (weak, nonatomic) IBOutlet UIImageView *arrowAr2;
@property (weak, nonatomic) IBOutlet UIImageView *arrowAr3;
@property (weak, nonatomic) IBOutlet UIImageView *arrowAr4;
@property (weak, nonatomic) IBOutlet UIImageView *arrowAr5;
@property (weak, nonatomic) IBOutlet UIImageView *arrowAr6;
@property (weak, nonatomic) IBOutlet UIImageView *arrowAr7;
- (IBAction)contactUsClicked:(id)sender;
- (IBAction)loginClicked:(id)sender;
- (IBAction)homeClicked:(id)sender;
- (IBAction)myListingClicked:(id)sender;
- (IBAction)addPropertyClicked:(id)sender;
- (IBAction)editProfileClicked:(id)sender;
- (IBAction)settingsClicked:(id)sender;
@end
