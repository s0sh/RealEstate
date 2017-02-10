//
//  FacebookviewController.h
//  Beefshock Restaurant
//
//  Created by Krunal Bhavsar on 07/06/14.
//  Copyright (c) 2014 peerbits. All rights reserved.
//

#import "FacebookviewController.h"
#import <FacebookSDK/FacebookSDK.h>

@interface FacebookviewController ()

@end

@implementation FacebookviewController
@synthesize FBDelegate,fromshop;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


-(void)checkFacebookLoginSession{
    //responseselector = sel;
    if (FBSession.activeSession.state == FBSessionStateCreatedTokenLoaded) {
        NSLog(@"Found a cached session");
        [FBSession openActiveSessionWithReadPermissions:@[@"email",@"user_friends",@"user_website",@"public_profile",@"read_friendlists"]
                                           allowLoginUI:NO
                                      completionHandler:^(FBSession *session, FBSessionState state, NSError *error) {
                                          [self sessionStateChanged:session state:state error:error];
                                      }];
    }
    else{
        if (FBSession.activeSession.state == FBSessionStateOpen || FBSession.activeSession.state == FBSessionStateOpenTokenExtended) {
            [FBSession.activeSession closeAndClearTokenInformation];
        } else {
            [FBSession openActiveSessionWithReadPermissions:@[@"email",@"user_friends",@"user_website",@"public_profile",@"read_friendlists"]
                                               allowLoginUI:YES
                                          completionHandler:^(FBSession *session, FBSessionState state, NSError *error) {
                                              [self sessionStateChanged:session state:state error:error];
                                              
                                          }];
        }
    }
}


- (void)viewDidLoad{
    [super viewDidLoad];
}

- (void)sessionStateChanged:(FBSession *)session state:(FBSessionState) state error:(NSError *)error{
    // If the session was opened successfully
    if (!error && state == FBSessionStateOpen){
        isLoggedInFacebook = YES;
        // Show the user the logged-in UI
        if (isRequireUserInfo) {
            [self getFacebookUserInfo:responseselector];
        }
        
        if (isRequireFriendList) {
            [self getFacebookFriendList:responseselector];
        }
        return;
    }
    if (state == FBSessionStateClosed || state == FBSessionStateClosedLoginFailed){
        // If the session is closed
        isLoggedInFacebook = NO;
    }
    
    // Handle errors
    if (error){
        [FBSession.activeSession closeAndClearTokenInformation];
        alerttitle = @"Facebook Log-in Error";
        alertmessage = [FBErrorUtility userMessageForError:error];
        
        // If the error requires people using an app to make an action outside of the app in order to recover
        if ([FBErrorUtility shouldNotifyUserForError:error] == YES){
            alerttitle = @"Permission";
            alertmessage = [NSString stringWithFormat:@"%@",[FBErrorUtility userMessageForError:error]];
            
        } else {
            if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryUserCancelled) {
                alerttitle = @"Sign-In Cancelled";
                alertmessage = @"Facebook sign-in is cancelled by user";
            } else if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryAuthenticationReopenSession){
                alerttitle = @"Session Error";
                alertmessage = @"Your current facebook session is no longer valid\nPlease sign-in again";
            } else {
                NSDictionary *errorInformation = [[[error.userInfo objectForKey:@"com.facebook.sdk:ParsedJSONResponseKey"] objectForKey:@"body"] objectForKey:@"error"];
                alerttitle = @"Something went wrong";
                alertmessage = [NSString stringWithFormat:@"Please retry.\n\n If the problem persists contact us and mention this error code: %@", [errorInformation objectForKey:@"message"]];
            }
        }
        [[[UIAlertView alloc]initWithTitle:alerttitle message:alertmessage delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
    }
}


#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
- (void)getFacebookUserInfo:(SEL)sel{
    
    if (!isLoggedInFacebook) {
        isRequireUserInfo = YES;
        responseselector = sel;
        [self loginWithFacebook];
    }else{
        //responseselector = responseselector;
        [FBRequestConnection startForMeWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
            if (!error) {
            // Success! Include your code to handle the results here
                [self.FBDelegate performSelector:sel withObject:result];
            } else {
                
            }
        }];
        
        isRequireUserInfo = NO;
    }
    
}

-(void)shareLinkOnFacebookWithDictionary:(NSDictionary *)params{
    
    [FBWebDialogs presentFeedDialogModallyWithSession:nil
                                           parameters:params
                                              handler:^(FBWebDialogResult result, NSURL *resultURL, NSError *error) {
                                                  if (error) {
                                                  } else {
                                                      if (result == FBWebDialogResultDialogNotCompleted) {
                                                      } else {
                                                          NSDictionary *urlParams = [self parseURLParams:[resultURL query]];
                                                          if (![urlParams valueForKey:@"post_id"]) {
                                                          } else {
                                                              NSString *result = [NSString stringWithFormat: @"Posted story, id: %@", [urlParams valueForKey:@"post_id"]];
                                                          }
                                                      }
                                                  }
                                              }];
}

- (NSDictionary *)parseURLParams:(NSString *)query {
    NSArray *pairs = [query componentsSeparatedByString:@"&"];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    for (NSString *pair in pairs) {
        NSArray *kv = [pair componentsSeparatedByString:@"="];
        NSString *val =
        [kv[1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        params[kv[0]] = val;
    }
    return params;
}


- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}


-(void)loginWithFacebook{
    //responseselector = sel;
    
    if (FBSession.activeSession.state == FBSessionStateCreatedTokenLoaded) {
        [FBSession openActiveSessionWithReadPermissions:@[@"email",@"user_friends",@"user_website",@"public_profile",@"read_friendlists"]
                                           allowLoginUI:NO
                                      completionHandler:^(FBSession *session, FBSessionState state, NSError *error) {
                                          [self sessionStateChanged:session state:state error:error];
                                      }];
    }else{
        if (FBSession.activeSession.state == FBSessionStateOpen || FBSession.activeSession.state == FBSessionStateOpenTokenExtended) {
            isLoggedInFacebook = YES;
        }else{
            /*
            [FBSession openActiveSessionWithPublishPermissions:@[@"email",@"user_friends",@"user_website",@"public_profile",@"read_friendlists"]
                                               defaultAudience:FBSessionDefaultAudienceEveryone
                                               allowLoginUI:YES
                                          completionHandler:^(FBSession *session, FBSessionState state, NSError *error) {
                                              [self sessionStateChanged:session state:state error:error];
                                          }];

            */
            [FBSession openActiveSessionWithReadPermissions:@[@"email",@"user_friends",@"user_website"]
                                               allowLoginUI:YES
                                          completionHandler:^(FBSession *session, FBSessionState state, NSError *error) {
                                              [self sessionStateChanged:session state:state error:error];
                                          }];
            
        }
    }
    
    

}

-(void)getFacebookFriendList:(SEL)sel{
    
    if (!isLoggedInFacebook) {
        isRequireFriendList = YES;
        responseselector = sel;
        [self loginWithFacebook];
    }else{
       
        [FBRequestConnection startWithGraphPath:@"/me/friends"
                                     parameters:nil
                                     HTTPMethod:@"GET"
                              completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                                  [self.FBDelegate performSelector:sel withObject:result];
                              }];
       
        isRequireFriendList = NO;
    }
    
}

-(void)logoutFromFacebook{
    isLoggedInFacebook = NO;
    [FBSession.activeSession closeAndClearTokenInformation];
}



@end
