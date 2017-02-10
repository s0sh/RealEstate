//
//  PropertyViewController.h
//  RealEstate
//
//  Created by macmini7 on 07/06/14.
//  Copyright (c) 2014 macmini7. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <MessageUI/MessageUI.h>
#import "FGalleryViewController.h"
#import "AddPropertyViewController.h"
#import "ModelClass.h"
#import "FeedViewController.h"
#import "FHSTwitterEngine.h"
#import <FacebookSDK/FacebookSDK.h>
@interface PropertyViewController : UIViewController<MKMapViewDelegate,UIAlertViewDelegate,MFMailComposeViewControllerDelegate,FHSTwitterEngineAccessTokenDelegate,MFMessageComposeViewControllerDelegate>{
    NSString * sPropertyId, * sUserId;
    int k;
    NSString * alerttitle, * alerterrormessage;
    BOOL isTweeting;
    CGFloat xtw,ytw,wtw,htw;
    
}

@property(strong)ModelClass *mc;
@property (strong, nonatomic) NSMutableDictionary* response;

@property (weak, nonatomic) IBOutlet MKMapView *palceMap;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UILabel *lblTitleMain;
@property (weak, nonatomic) IBOutlet UILabel *lblLocation;
@property (weak, nonatomic) IBOutlet UILabel *lblPrice;
@property (weak, nonatomic) IBOutlet UILabel *lblType;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UILabel *txtViewDescrption;
@property (weak, nonatomic) IBOutlet UILabel *lblDescription;
@property (weak, nonatomic) IBOutlet UIImageView *divider;
@property (weak, nonatomic) IBOutlet UIImageView *image_imagegallary;
@property (strong, nonatomic) IBOutlet UIImageView *imgProperty;
@property (weak, nonatomic) IBOutlet UIView *btnContact;
@property (weak, nonatomic) IBOutlet UIButton *button_editproperty;
@property (weak, nonatomic) IBOutlet UIButton *button_next_image;
@property (weak, nonatomic) IBOutlet UIButton *button_previous_image;
@property (weak, nonatomic) IBOutlet UIButton *button_previous_imagegallary;
@property (weak, nonatomic) IBOutlet UIButton *button_next_imagegallary;
@property (weak, nonatomic) IBOutlet UIButton *button_zoomout_imagegallary;
@property (strong, nonatomic) IBOutlet UIView *view_imagegallary;
@property (weak, nonatomic) IBOutlet UIView *view_socialsharing;
@property (weak, nonatomic) IBOutlet UILabel *label_sharewith;
@property (weak, nonatomic) IBOutlet UIImageView *image_twitter_sharing_image;
@property (weak, nonatomic) IBOutlet UITextView *textview_twitter_sharing_comment;
@property (weak, nonatomic) IBOutlet UIButton *button_tweet;
@property (strong, nonatomic) IBOutlet UIView *view_tweeter_view;
@property (weak, nonatomic) IBOutlet UILabel *label_tweet_limit;
@property (weak, nonatomic) IBOutlet UILabel *lblDescriptionCaption;
@property (weak, nonatomic) IBOutlet UILabel *lblShareWithCaption;
@property (weak, nonatomic) IBOutlet UILabel *lblTitleCaption;
@property (weak, nonatomic) IBOutlet UILabel *lblLocationCaption;
@property (weak, nonatomic) IBOutlet UILabel *lblTypeCaption;
@property (weak, nonatomic) IBOutlet UILabel *lblCostCaption;
@property (weak, nonatomic) IBOutlet UILabel *lblZoningCaption;
@property (weak, nonatomic) IBOutlet UILabel *lblZoning;
@property (weak, nonatomic) IBOutlet UIImageView *imgMapDivider;
@property (weak, nonatomic) IBOutlet UIImageView *lblMapDivider1;
@property (weak, nonatomic) IBOutlet UIButton *btnFbShare;
@property (weak, nonatomic) IBOutlet UIButton *btnTwitterShare;
@property (weak, nonatomic) IBOutlet UIButton *btnGoogleShare;
- (IBAction)btnBackClicked:(id)sender;
- (IBAction)contactAgentClicked:(id)sender;
- (IBAction)editProperty:(id)sender;
- (IBAction)changeImage:(UIButton *)button;
- (IBAction)zoomoutFromGallery:(id)sender;
- (IBAction)zoomInGallery:(id)sender;
- (IBAction)shareWith:(UIButton *)sender;
- (IBAction)tweetOnTwitter:(id)sender;
- (IBAction)cancelTweet:(id)sender;

-(void)shareWithFacebook;
-(void)shareWithTwitter;
-(void)shareWithGoogle;
@end
