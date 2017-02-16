//
//  SelectLanguageViewController.h
//  RealEstate
//
//  Created by Roman Bigun on 29/08/14.
//  Copyright (c) 2014 Roman Bigun All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SelectLanguageViewController : UIViewController<UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *lblSelectLabel;
@property (weak, nonatomic) IBOutlet UIButton *btnEnglishlang;
@property (weak, nonatomic) IBOutlet UIButton *btnSelectArbiLang;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
- (IBAction)englishLangClicked:(id)sender;
- (IBAction)arbiLangClicked:(id)sender;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil normal:(BOOL)normal;
- (IBAction)menuClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *viewTitle;
@property (weak, nonatomic) IBOutlet UIButton *btnMenu;
@end
