//
//  LoginViewController.h
//  RealEstate
//
//  Created by macmini7 on 05/06/14.
//  Copyright (c) 2014 macmini7. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ModelClass.h"
#import "FHSTwitterEngine.h"
#import "MenuViewViewController.h"

@interface LoginViewController : UIViewController<FHSTwitterEngineAccessTokenDelegate>

@property(strong)ModelClass *mc;
@property (weak, nonatomic) IBOutlet UIButton *btnRegister;
@property (weak, nonatomic) IBOutlet UIButton *btnLogin;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UITextField *txtUserName;
@property (weak, nonatomic) IBOutlet UITextField *txtPassword;
@property (weak, nonatomic) IBOutlet UIScrollView *scroll_loginform;
@property (weak, nonatomic) IBOutlet UIImageView *imgViewUserBg;
@property (weak, nonatomic) IBOutlet UIImageView *imgViewPassBg;
@property (weak, nonatomic) IBOutlet UIButton *btnMenu;


- (IBAction)loginClicked:(id)sender;
- (IBAction)registerClicked:(id)sender;
- (IBAction)fbLoginClicked:(id)sender;
- (IBAction)twitterLoginClicked:(id)sender;
- (IBAction)menuCLicked:(id)sender;
@end
