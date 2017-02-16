//
//  MenuViewViewController.m
//  RealEstate
//
//  Created by Roman Bigun on 09/06/14.
//  Copyright (c) 2014 Roman Bigun All rights reserved.
//

#import "MenuViewViewController.h"
#import "LoginViewController.h"
#import "ContactUsViewController.h"
#import "MFSideMenu.h"
#import "FeedViewController.h"
#import "UIImageView+WebCache.h"
#import <QuartzCore/QuartzCore.h>
#import "EditProfileViewController.h"
#import "SelectLanguageViewController.h"
@interface MenuViewViewController ()

@end

@implementation MenuViewViewController{
    
    BOOL isLoggedIn;
    CGRect withEdit;
    CGRect withOutEdit;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //Setfonts
    
    DELEGATE.isComingFromMyListing = NO;
    
    withEdit=_container.frame;
    withOutEdit=CGRectMake(_container.frame.origin.x, _container.frame.origin.y-47, _container.frame.size.width, _container.frame.size.height);
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(loginToggle)
                                                 name:@"userlogin"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(localization)
                                                 name:@"localizeComponents"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(logout)
                                                 name:@"logout"
                                               object:nil];
    if ([[NSUserDefaults standardUserDefaults] valueForKey:@"user"]) {
        [self loginToggle];
    }else{
        self.container.frame=withOutEdit;
        [self.button_login setTitle:[LOCALIZATION localizedStringForKey:@"login"] forState:UIControlStateNormal];
    }
}
-(void)logout{
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"user"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    FeedViewController *detail=[[FeedViewController alloc]initWithNibName:@"FeedViewController" bundle:nil];
    UINavigationController *navigationController = self.menuContainerViewController.centerViewController;
    NSArray *controllers = [NSArray arrayWithObject:detail];
    navigationController.viewControllers = controllers;
    [self.menuContainerViewController setMenuState:MFSideMenuStateClosed];
    _viewPropic.hidden=YES;
    isLoggedIn=NO;
    self.container.frame=withOutEdit;
    if (DELEGATE.isFacebookLogin) {
        FacebookviewController *facebook =[[FacebookviewController alloc]init];
        facebook.FBDelegate=self;
        [facebook logoutFromFacebook];
        DELEGATE.isFacebookLogin = NO;
    }
    [self.button_login setTitle:[LOCALIZATION localizedStringForKey:@"login"] forState:UIControlStateNormal];;
}
- (void)loginToggle{
    self.viewPropic.hidden=NO;
    isLoggedIn=YES;
    NSDictionary *userDetail=[NSDictionary dictionaryWithDictionary:[[NSUserDefaults standardUserDefaults] valueForKey:@"user"]];
    _lblUserName.text=[NSString stringWithFormat:@"%@ %@",[userDetail valueForKey:@"firstname"],[userDetail valueForKey:@"lastname"]];
    [self.button_login setTitle:[LOCALIZATION localizedStringForKey:@"logout"] forState:UIControlStateNormal];
    _container.frame=withEdit;
}
-(void)viewWillAppear:(BOOL)animated{
    [self localization];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated. ContactUsViewController
}

- (IBAction)contactUsClicked:(id)sender {
    ContactUsViewController *detail=[[ContactUsViewController alloc]initWithNibName:@"ContactUsViewController" bundle:nil];
    UINavigationController *navigationController = self.menuContainerViewController.centerViewController;
    NSArray *controllers = [NSArray arrayWithObject:detail];
    navigationController.viewControllers = controllers;
    [self.menuContainerViewController setMenuState:MFSideMenuStateClosed];
}

- (IBAction)loginClicked:(id)sender {
    
    if (isLoggedIn || DELEGATE.isFacebookLogin) {
        UIAlertView *Alert=[[UIAlertView alloc]initWithTitle:@"Alert" message:[LOCALIZATION localizedStringForKey:@"sure"] delegate:self cancelButtonTitle:[LOCALIZATION localizedStringForKey:@"no"] otherButtonTitles:[LOCALIZATION localizedStringForKey:@"yes"], nil];
        [Alert show];
        return;
    }
    LoginViewController *detail=[[LoginViewController alloc]initWithNibName:@"LoginViewController" bundle:nil];
    UINavigationController *navigationController = self.menuContainerViewController.centerViewController;
    NSArray *controllers = [NSArray arrayWithObject:detail];
    navigationController.viewControllers = controllers;
    [self.menuContainerViewController setMenuState:MFSideMenuStateClosed];
}

- (IBAction)homeClicked:(id)sender {
    DELEGATE.isComingFromMyListing = NO;
    FeedViewController *detail=[[FeedViewController alloc]initWithNibName:@"FeedViewController" bundle:nil];
    UINavigationController *navigationController = self.menuContainerViewController.centerViewController;
    NSArray *controllers = [NSArray arrayWithObject:detail];
    navigationController.viewControllers = controllers;
    [self.menuContainerViewController setMenuState:MFSideMenuStateClosed];
}

- (IBAction)myListingClicked:(id)sender {
    int userid = [[USER_DEFAULTS valueForKeyPath:@"user.userid"] intValue];
    DELEGATE.isComingFromMyListing = YES;
    if (userid !=0) {
        FeedViewController *detail=[[FeedViewController alloc]initWithNibName:@"FeedViewController" bundle:nil];
        UINavigationController *navigationController = self.menuContainerViewController.centerViewController;
        NSArray *controllers = [NSArray arrayWithObject:detail];
        navigationController.viewControllers = controllers;
        [self.menuContainerViewController setMenuState:MFSideMenuStateClosed];
    }else{
        [self loginClicked:nil];
    }
}

- (IBAction)addPropertyClicked:(id)sender {
    DELEGATE.isAddingProperty = YES;
    int userid = [[USER_DEFAULTS valueForKeyPath:@"user.userid"] intValue];
    if (userid !=0) {
        AddPropertyViewController * apvc = [[AddPropertyViewController alloc]initWithNibName:NSStringFromClass([AddPropertyViewController class]) bundle:nil];
        UINavigationController *navigationController = self.menuContainerViewController.centerViewController;
        NSArray *controllers = [NSArray arrayWithObject:apvc];
        navigationController.viewControllers = controllers;
        [self.menuContainerViewController setMenuState:MFSideMenuStateClosed];
        
    }else{
        [self loginClicked:nil];
    }
}

- (IBAction)editProfileClicked:(id)sender {
    EditProfileViewController *detail=[[EditProfileViewController alloc]initWithNibName:@"EditProfileViewController" bundle:nil];
    UINavigationController *navigationController = self.menuContainerViewController.centerViewController;
    NSArray *controllers = [NSArray arrayWithObject:detail];
    navigationController.viewControllers = controllers;
    [self.menuContainerViewController setMenuState:MFSideMenuStateClosed];
}

- (IBAction)settingsClicked:(id)sender {
    SelectLanguageViewController *detail=[[SelectLanguageViewController alloc]initWithNibName:@"SelectLanguageViewController" bundle:nil normal:NO];
    UINavigationController *navigationController = self.menuContainerViewController.centerViewController;
    NSArray *controllers = [NSArray arrayWithObject:detail];
    navigationController.viewControllers = controllers;
    [self.menuContainerViewController setMenuState:MFSideMenuStateClosed];
}

//Alert view delegate method
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==1) {
        [[NSNotificationCenter defaultCenter]postNotificationName:@"logout" object:self];
    }
}
//Localization stuffs
-(void)localization{

    if ([[NSUserDefaults standardUserDefaults] valueForKey:@"user"]) {
        [self.button_login setTitle:[LOCALIZATION localizedStringForKey:@"logout"] forState:UIControlStateNormal];
    }else{
        [self.button_login setTitle:[LOCALIZATION localizedStringForKey:@"login"] forState:UIControlStateNormal];
    }
    [self.button_home setTitle:[LOCALIZATION localizedStringForKey:@"home"] forState:UIControlStateNormal];
    [self.btnEditProfile setTitle:[LOCALIZATION localizedStringForKey:@"editprofile"] forState:UIControlStateNormal];
    [self.button_mylisting setTitle:[LOCALIZATION localizedStringForKey:@"mylisting"] forState:UIControlStateNormal];
    [self.button_addProperty setTitle:[LOCALIZATION localizedStringForKey:@"addproperty"] forState:UIControlStateNormal];
    [self.button_contact_us setTitle:[LOCALIZATION localizedStringForKey:@"contactus"] forState:UIControlStateNormal];
    [self.button_mylisting setTitle:[LOCALIZATION localizedStringForKey:@"mylisting"] forState:UIControlStateNormal];
    [self.btnSettings setTitle:[LOCALIZATION localizedStringForKey:@"settings"] forState:UIControlStateNormal];
    _lblHello.text=[LOCALIZATION localizedStringForKey:@"hello"];
   // [self adjustAlignment];//
}
-(void)adjustAlignment{
    CGRect frame;
    if ([[USER_DEFAULTS valueForKey:@"localization"] isEqualToString:@"AR"]) {
        frame=_lblHello.frame;
        frame.origin.x=210;
        _lblHello.frame=frame;
        
        frame=_lblUserName.frame;
        frame.origin.x=0;
        _lblUserName.frame=frame;
        _lblUserName.textAlignment=NSTextAlignmentRight;
        
        _button_home.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        _btnEditProfile.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        self.button_mylisting.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        self.button_addProperty.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        self.button_contact_us.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        self.button_mylisting.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        self.btnSettings.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        self.button_login.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        
        [self hideEnArrows];
        
    }else{
        frame=_lblHello.frame;
        frame.origin.x=20;
        _lblHello.frame=frame;
        
        frame=_lblUserName.frame;
        frame.origin.x=70;
        _lblUserName.frame=frame;
        _lblUserName.textAlignment=NSTextAlignmentLeft;
        
        _button_home.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        _btnEditProfile.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        _button_home.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        _btnEditProfile.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        self.button_mylisting.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        self.button_addProperty.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        self.button_contact_us.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        self.button_mylisting.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        self.btnSettings.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        self.button_login.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [self hideArArrows];
    }
}
-(void)hideEnArrows{
    
    _arrowEn1.hidden=YES;
    _arrowEn2.hidden=YES;
    _arrowEn3.hidden=YES;
    _arrowEn4.hidden=YES;
    _arrowEn5.hidden=YES;
    _arrowEn6.hidden=YES;
    _arrowEn7.hidden=YES;
   
    _arrowAr1.hidden=NO;
    _arrowAr2.hidden=NO;
    _arrowAr3.hidden=NO;
    _arrowAr4.hidden=NO;
    _arrowAr5.hidden=NO;
    _arrowAr6.hidden=NO;
    _arrowAr7.hidden=NO;
    
    
}

-(void)hideArArrows{
    
    _arrowEn1.hidden=NO;
    _arrowEn2.hidden=NO;
    _arrowEn3.hidden=NO;
    _arrowEn4.hidden=NO;
    _arrowEn5.hidden=NO;
    _arrowEn6.hidden=NO;
    _arrowEn7.hidden=NO;
    
    _arrowAr1.hidden=YES;
    _arrowAr2.hidden=YES;
    _arrowAr3.hidden=YES;
    _arrowAr4.hidden=YES;
    _arrowAr5.hidden=YES;
    _arrowAr6.hidden=YES;
    _arrowAr7.hidden=YES;
    
    
}


@end
