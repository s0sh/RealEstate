//
//  AppDelegate.h
//  RealEstate
//
//  Created by Roman Bigun on 04/06/14.
//  Copyright (c) 2014 Roman Bigun All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FacebookviewController.h"
#import "DarckWaitView.h"
#import "GADBannerView.h"


extern NSString *const FBSessionStateChangedNotification;

@interface AppDelegate : UIResponder <UIApplicationDelegate>{
        GADBannerView *AbMob;
}

@property (strong, nonatomic) DarckWaitView *drk;
@property (strong, nonatomic) UIWindow *window;
@property (retain, nonatomic) UINavigationController *navigationController;
@property (retain, nonatomic) UIViewController *home;
@property BOOL isAddingProperty, isEditingProperty, isComingFromMyListing, isFacebookLogin;

-(NSString*)trimWhiteSpaces:(NSString*)text;

@property (nonatomic, retain) NSString *TokeinID;

- (BOOL)openSessionWithAllowLoginUI:(BOOL)allowLoginUI;
-(void)addIntegration:(UIViewController *)viewcontroller;
@end
