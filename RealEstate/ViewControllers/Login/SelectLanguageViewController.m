//
//  SelectLanguageViewController.m
//  RealEstate
//
//  Created by macmini7 on 29/08/14.
//  Copyright (c) 2014 macmini7. All rights reserved.
//

#import "SelectLanguageViewController.h"
#import "FeedViewController.h"
#import "MenuViewViewController.h"
#import "MFSideMenu.h"

@interface SelectLanguageViewController ()

@end

@implementation SelectLanguageViewController{
    
    BOOL isNormal;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    isNormal=YES;
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil normal:(BOOL)normal
{
    isNormal=NO;
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (IBAction)menuClicked:(id)sender {
    
    if ([[USER_DEFAULTS valueForKey:@"localization"] isEqualToString:@"AR"]) {
        [self.menuContainerViewController toggleRightSideMenuCompletion:^{
            
        }];
    }else{
        [self.menuContainerViewController toggleLeftSideMenuCompletion:^{
            
        }];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    if (isNormal) {
        _viewTitle.hidden=YES;
    }else{
         _viewTitle.hidden=NO;
    }
}
-(void)viewWillAppear:(BOOL)animated{
    [self localization];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)englishLangClicked:(id)sender {
    [USER_DEFAULTS setValue:@"EN" forKey:@"localization"];
    [USER_DEFAULTS synchronize];
    [LOCALIZATION setLanguage:@"EN"];
    [self showPopUp];
    [self localization];
}

- (IBAction)arbiLangClicked:(id)sender {
    [USER_DEFAULTS setValue:@"AR" forKey:@"localization"];
    [USER_DEFAULTS synchronize];
    [LOCALIZATION setLanguage:@"AR"];
    [self showPopUp];
    [self localization];
    
}
-(void)pushToHome{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"localizeComponents" object:self];
    
    if (!isNormal) {
        return;
    }
    DELEGATE.isComingFromMyListing = NO;
    FeedViewController *detail=[[FeedViewController alloc]initWithNibName:@"FeedViewController" bundle:nil];
    UINavigationController *navigationController = self.menuContainerViewController.centerViewController;
    NSArray *controllers = [NSArray arrayWithObject:detail];
    navigationController.viewControllers = controllers;
    [self.menuContainerViewController setMenuState:MFSideMenuStateClosed];
}
-(void)showPopUp{
 
    if (isNormal) {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Erminesoft" message:[LOCALIZATION localizedStringForKey:@"languageMsg"] delegate:self cancelButtonTitle:[LOCALIZATION localizedStringForKey:@"ok"] otherButtonTitles: nil];
        [alert show];
    }else{
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Erminesoft" message:[LOCALIZATION localizedStringForKey:@"laguageset"] delegate:self cancelButtonTitle:[LOCALIZATION localizedStringForKey:@"ok"] otherButtonTitles: nil];
        [alert show];
    }
    
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    [self pushToHome];
}

//Localization stuffs
-(void)localization{
    [self.lblTitle setText:[LOCALIZATION localizedStringForKey:@"language"]];
    if ([USER_DEFAULTS valueForKey:@"localization"]) {
        [self.lblSelectLabel setText:[LOCALIZATION localizedStringForKey:@"selectlanguage"]];
    }
    [self adjustAlignment];
}
-(void)adjustAlignment{
    CGRect frame;
    if ([[USER_DEFAULTS valueForKey:@"localization"] isEqualToString:@"AR"]) {
        frame=_btnMenu.frame;
        frame.origin.x=frame.origin.x=240;
        _btnMenu.frame=frame;
    }else{
        frame=_btnMenu.frame;
        frame.origin.x=frame.origin.x=-20;
        _btnMenu.frame=frame;
    }
}

@end
