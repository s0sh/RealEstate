//
//  FacebookviewController.h
//  Beefshock Restaurant
//
//  Created by Krunal Bhavsar on 07/06/14.
//  Copyright (c) 2014 peerbits. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FacebookViewControllerDelegate <NSObject>


@optional


@end

@interface FacebookviewController : UIViewController<FacebookViewControllerDelegate>{
    SEL responseselector;
    NSString * alerttitle, * alertmessage;
    BOOL isLoggedInFacebook, isRequireUserInfo, isRequireFriendList;
    
}
@property (nonatomic, retain) id FBDelegate;
@property (nonatomic,assign)BOOL fromshop;

- (void)loginWithFacebook;
- (void)logoutFromFacebook;
- (void)getFacebookUserInfo:(SEL)sel;
- (void)checkFacebookLoginSession;
- (void)getFacebookFriendList:(SEL)sel;
- (void)shareLinkOnFacebookWithDictionary:(NSDictionary *)params;



@end



