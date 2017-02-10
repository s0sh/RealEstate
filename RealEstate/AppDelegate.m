//
//  AppDelegate.m
//  RealEstate
//
//  Created by macmini7 on 04/06/14.
//  Copyright (c) 2014 macmini7. All rights reserved.
//

#import "AppDelegate.h"
#import "LoginViewController.h"
#import "FeedViewController.h"
#import <FacebookSDK/FacebookSDK.h>
#import "ContactUsViewController.h"
#import "MenuViewViewController.h"
#import "MFSideMenuContainerViewController.h"
#import "LocationServices.h"
#import "EmailViewController.h"
#import "SelectLanguageViewController.h"


NSString *const FBSessionStateChangedNotification = @"com.peerbits.facebook:FBSessionStateChangedNotification";

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleLightContent];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    //Location stuff
   

    [LocationServices initializeService];
    [gLocationServices startUpdateLocation];
    
    if ([USER_DEFAULTS valueForKey:@"localization"]) {
        self.home=[[FeedViewController alloc]initWithNibName:@"FeedViewController" bundle:nil];
        [LOCALIZATION setLanguage:[USER_DEFAULTS valueForKey:@"localization"]];
    }else{
        self.home=[[SelectLanguageViewController alloc]initWithNibName:@"SelectLanguageViewController" bundle:nil];
    }
    
    self.navigationController=[[UINavigationController alloc]initWithRootViewController:self.home];
    MenuViewViewController *leftMenuViewController = [[MenuViewViewController alloc] initWithNibName:@"MenuViewViewController" bundle:nil];
     MenuViewViewController *rightMenuViewController = [[MenuViewViewController alloc] initWithNibName:@"MenuViewViewController" bundle:nil];
    MFSideMenuContainerViewController *container = [MFSideMenuContainerViewController
                                                    containerWithCenterViewController:self.navigationController
                                                    leftMenuViewController:leftMenuViewController
                                                    rightMenuViewController:rightMenuViewController];
    
    [self openSessionWithAllowLoginUI:NO];
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;

    [self.navigationController setNavigationBarHidden:YES];
    self.window.rootViewController = container;
    self.window.backgroundColor = [UIColor whiteColor];
    sleep(2);
    [self.window makeKeyAndVisible];
    return YES;
}


- (BOOL)openSessionWithAllowLoginUI:(BOOL)allowLoginUI {
    NSArray *permissionsNeeded = @[@"public_profile",@"email", @"user_friends"];
    return [FBSession openActiveSessionWithReadPermissions:permissionsNeeded
                                              allowLoginUI:allowLoginUI
                                         completionHandler:^(FBSession *session, FBSessionState state, NSError *error) {
                                             [self sessionStateChanged:session state:state error:error];
                                         }];
}

- (void)sessionStateChanged:(FBSession *)session state:(FBSessionState) state error:(NSError *)error{
    switch (state) {
        case FBSessionStateOpen:
            if (!error) {
            }
            break;
        case FBSessionStateClosed:
            break;
        case FBSessionStateClosedLoginFailed:
            [FBSession.activeSession closeAndClearTokenInformation];
            break;
        default:
            break;
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:FBSessionStateChangedNotification object:session];
    
    if (error) {
        [[[UIAlertView alloc] initWithTitle:@"Error" message:error.localizedDescription delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    }
}

- (void) closeSession {
    [FBSession.activeSession closeAndClearTokenInformation];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    
    return ([FBSession.activeSession handleOpenURL:url]);
    
}

- (void)application:(UIApplication *)app didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    self.TokeinID =[NSString stringWithFormat:@"%@",deviceToken];
    self.TokeinID = [self.TokeinID stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
	self.TokeinID = [[NSString alloc]initWithFormat:@"%@",[self.TokeinID stringByReplacingOccurrencesOfString:@" " withString:@""]];
    
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [FBAppCall handleDidBecomeActive];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
//MEthod to trim whitspaces
-(NSString*)trimWhiteSpaces:(NSString*)text{
    return  [text stringByTrimmingCharactersInSet:
             [NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

-(void)addIntegration:(UIViewController *)viewcontroller
{
    /*
    if([[[UIDevice currentDevice] systemVersion]floatValue ]>=7)
    {
        AbMob = [[GADBannerView alloc]
                 initWithFrame:CGRectMake(0.0,
                                          self.window.frame.size.height -
                                          GAD_SIZE_320x50.height,
                                          GAD_SIZE_320x50.width,
                                          GAD_SIZE_320x50.height)];
    }
    else
    {
        AbMob = [[GADBannerView alloc]
                 initWithFrame:CGRectMake(0.0,
                                          self.window.bounds.size.height -
                                          GAD_SIZE_320x50.height-20,
                                          GAD_SIZE_320x50.width,
                                          GAD_SIZE_320x50.height)];
    }
    
    
    AbMob.adUnitID = AdMob_ID;
    AbMob.rootViewController = viewcontroller;
    [viewcontroller.view addSubview:AbMob];
    
    [AbMob loadRequest:[GADRequest request]];
     */
}

@end
