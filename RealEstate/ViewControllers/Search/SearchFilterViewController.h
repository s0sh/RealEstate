//
//  SearchFilterViewController.h
//  RealEstate
//
//  Created by macmini7 on 10/06/14.
//  Copyright (c) 2014 macmini7. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ModelClass.h"
#import "TPKeyboardAvoidingScrollView.h"
#import "BSKeyboardControls.h"


@interface SearchFilterViewController : UIViewController<BSKeyboardControlsDelegate>
@property(strong)ModelClass *mc;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
- (IBAction)btnBackClicked:(id)sender;
- (IBAction)searchMapClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *txtStartPrice;
@property (weak, nonatomic) IBOutlet UITextField *txtEndPrice;
@property (weak, nonatomic) IBOutlet UITextField *txtLocation;
@property (weak, nonatomic) IBOutlet UIButton *btnTypeSell;
@property (weak, nonatomic) IBOutlet UIButton *btnTypeRent;
@property (weak, nonatomic) IBOutlet UIButton *btnTypeInvest;
@property (weak, nonatomic) IBOutlet UIButton *btnTypeOther;
@property (weak, nonatomic) IBOutlet UIButton *btnZoneResidential;
@property (weak, nonatomic) IBOutlet UIButton *btnZoneRetail;
@property (weak, nonatomic) IBOutlet UIButton *btnZoneCommercial;
@property (weak, nonatomic) IBOutlet UIButton *btnZoneMixed;
@property (strong, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet TPKeyboardAvoidingScrollView *scroll;
@property (weak, nonatomic) IBOutlet UITextField *txtOther;
@property (nonatomic, strong) BSKeyboardControls *keyboardControls;
@property (weak, nonatomic) IBOutlet UIView *buttomView;
- (IBAction)typeClicked:(UIButton *)sender;
- (IBAction)zoneClicked:(UIButton *)sender;
- (IBAction)searchClciked:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *btnTypeAll;
@property (weak, nonatomic) IBOutlet UIButton *btnZoneAll;
@property (weak, nonatomic) IBOutlet UIButton *btnSearchFilter;
@property (weak, nonatomic) IBOutlet UILabel *lblPropertyTypeCap;
@property (weak, nonatomic) IBOutlet UILabel *lblZoninigCap;
@property (weak, nonatomic) IBOutlet UILabel *lblProAll;
@property (weak, nonatomic) IBOutlet UILabel *lblProSell;
@property (weak, nonatomic) IBOutlet UILabel *lblProOther;
@property (weak, nonatomic) IBOutlet UILabel *lblProRent;
@property (weak, nonatomic) IBOutlet UILabel *lblProinvestment;
@property (weak, nonatomic) IBOutlet UILabel *lblZoAll;
@property (weak, nonatomic) IBOutlet UILabel *lblZoCommercial;
@property (weak, nonatomic) IBOutlet UILabel *lblZoMixed;
@property (weak, nonatomic) IBOutlet UILabel *lblZoResidential;
@property (weak, nonatomic) IBOutlet UILabel *lblZoRetail;



@end
