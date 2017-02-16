//
//  PropertyViewController.m
//  RealEstate
//
//  Created by Roman Bigun on 07/06/14.
//  Copyright (c) 2014 Roman Bigun All rights reserved.
//

#import "PropertyViewController.h"
#import "UIImageView+WebCache.h"
#import "Annotations.h"
#import <GoogleOpenSource/GoogleOpenSource.h>
#import "UIAlertHelper.h"
#import <MapKit/MapKit.h>
#import "EmailViewController.h"


#define METERS_PER_MILE 300.0

@interface PropertyViewController ()

@end

@implementation PropertyViewController{
    
    UIAlertView *contactAlert;
    NSMutableArray * propertyImagesArray;
    NSMutableArray *m_invitableFriends;
    FGalleryViewController *networkGallery;
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
    [DELEGATE addIntegration:self];
    
    [self.scrollView setContentSize:CGSizeMake(320.0, 685)];
    [self setFont];
    [self prepareMapNonAssigned];
    [_button_editproperty setHidden:!DELEGATE.isComingFromMyListing];
    [_btnContact setHidden:DELEGATE.isComingFromMyListing];
    
    
}
-(void)viewWillAppear:(BOOL)animated{
    
    self.navigationController.navigationBar.hidden=YES;
    [self localization];
}
-(void)setFont{
    CGSize maximumLabelSize = CGSizeMake(280, FLT_MAX);
    NSLog(@"zakir%@",_response);
    [self.imgProperty sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMAGE_PATH,[[_response valueForKey:@"Property"] valueForKey:@"image"]]] placeholderImage:[UIImage imageNamed:@"home_placeholder.png"]];
    [_image_imagegallary sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMAGE_PATH,[[_response valueForKey:@"Property"] valueForKey:@"image"]]] placeholderImage:[UIImage imageNamed:@"home_placeholder.png"]];
    
    self.lblPrice.text=[NSString stringWithFormat:@"%@ USD",[[_response valueForKey:@"Property"] valueForKey:@"price"]];
    self.lblTitle.text=[[_response valueForKey:@"Property"] valueForKey:@"title"];
    self.lblLocation.text=[NSString stringWithFormat:@"%@,%@,%@",[[_response valueForKey:@"Property"] valueForKey:@"location"],[[_response valueForKey:@"Property"] valueForKey:@"city"],[[_response valueForKey:@"Property"] valueForKey:@"country"]];
    self.lblZoning.text=[[_response valueForKey:@"Property"] valueForKey:@"zoning"];
    if ([[[_response valueForKey:@"Property"] valueForKey:@"is_other"] isEqualToString:@"Y"]) {
        self.lblType.text=[NSString stringWithFormat:@"%@",[[_response valueForKey:@"Property"] valueForKey:@"other_value"]];
    }else{
        if ([[[_response valueForKey:@"Property"] valueForKey:@"property_type"] isEqualToString:@"Sell"]) {
            self.lblType.text=[LOCALIZATION localizedStringForKey:[LOCALIZATION localizedStringForKey:@"sell"]];
        }else{
            self.lblType.text=[NSString stringWithFormat:@"%@",[[_response valueForKey:@"Property"] valueForKey:@"property_type"]];
        }
        if ([[NSUserDefaults standardUserDefaults] valueForKey:@"user"] && [[[_response valueForKey:@"Property"] valueForKey:@"id"] isEqualToString:[[NSUserDefaults standardUserDefaults] valueForKey:@"userid"]]) {
            self.lblType.text=[NSString stringWithFormat:@"%@",[[_response valueForKey:@"Property"] valueForKey:@"property_type"]];
        }
    }
    _lblDescription.text = [[_response valueForKey:@"Property"] valueForKey:@"description"];
    CGSize expectedLabelSize = [[[_response valueForKey:@"Property"] valueForKey:@"description"] sizeWithFont:_lblDescription.font constrainedToSize:maximumLabelSize lineBreakMode:_lblDescription.lineBreakMode];
    CGRect newFrame = _lblDescription.frame;
    newFrame.size.height = expectedLabelSize.height;
    _lblDescription.frame = newFrame;
    
    
    k=0;
    propertyImagesArray = [[NSMutableArray alloc] init];
    for (int i=0; i<[[[_response valueForKey:@"Property"] valueForKey:@"images"] count]; i++) {
        [propertyImagesArray addObject:[NSString stringWithFormat:@"%@%@",IMAGE_PATH,[[[[_response valueForKey:@"Property"] valueForKey:@"images"] objectAtIndex:i] valueForKey:@"image"]]];
    }
    
    (propertyImagesArray.count > 1) ? ([_button_next_image setHidden:NO]) : ([_button_next_image setHidden:YES]);
    (propertyImagesArray.count > 1) ? ([_button_next_imagegallary setHidden:NO]) : ([_button_next_imagegallary setHidden:YES]);
    [self adjust];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btnBackClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
//map logic
-(void)prepareMapNonAssigned{
    
    //Remove annotation placed before
    [self removeAnnotaions];
    //Add annotations
    CLLocationCoordinate2D driver;
    driver.latitude = [[[_response valueForKey:@"Property"] valueForKey:@"latitude"] doubleValue];
    driver.longitude = [[[_response valueForKey:@"Property"] valueForKey:@"longitude"] doubleValue];
    Annotations *annotaion1=[Annotations alloc];
    annotaion1.coordinate= driver;
    //annotaion1.title=[NSString stringWithFormat:@"%@",[[drivers objectAtIndex:i] valueForKey:@"name"]];
    //annotaion1.title=[NSString stringWithString:[[resultPlaces objectAtIndex:index]valueForKey:@"name"]];
    [self.palceMap addAnnotation:annotaion1];
    [self zoomToLocation];
}
//Remove previously added annotation
-(void)removeAnnotaions{
    NSInteger toRemoveCount = self.palceMap.annotations.count;
    NSMutableArray *toRemove = [NSMutableArray arrayWithCapacity:toRemoveCount];
    for (id annotation in self.palceMap.annotations)
        if (annotation != self.palceMap.userLocation)
            [toRemove addObject:annotation];
    [self.palceMap removeAnnotations:toRemove];
}
//Annotation Image change
- (MKAnnotationView *)mapView:(MKMapView *)map viewForAnnotation:(id <MKAnnotation>)annotation
{
    static NSString *annotationViewReuseIdentifier = @"annotationViewReuseIdentifier";
    MKAnnotationView *annotationView = (MKAnnotationView *)[self.palceMap dequeueReusableAnnotationViewWithIdentifier:annotationViewReuseIdentifier];
    if (annotationView == nil)
    {
        annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:annotationViewReuseIdentifier];
    }
    annotationView.image = [UIImage imageNamed:@"mapPin.png"];
    annotationView.annotation = annotation;
    
    return annotationView;
}
//Zoom to fit annotations
- (void)zoomToLocation{
    CLLocationCoordinate2D zoomLocation;
    zoomLocation.latitude = [[[_response valueForKey:@"Property"] valueForKey:@"latitude"] doubleValue];
    zoomLocation.longitude= [[[_response valueForKey:@"Property"] valueForKey:@"longitude"] doubleValue];
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(zoomLocation, 7.5*METERS_PER_MILE,7.5*METERS_PER_MILE);
    [self.palceMap setRegion:viewRegion animated:YES];
    [self.palceMap regionThatFits:viewRegion];
}
- (IBAction)contactAgentClicked:(id)sender {
    contactAlert=[[UIAlertView alloc]initWithTitle:@"Alert" message:[LOCALIZATION localizedStringForKey:@"contactvia"] delegate:self cancelButtonTitle:[LOCALIZATION localizedStringForKey:@"cancel"] otherButtonTitles:[LOCALIZATION localizedStringForKey:@"sms"],[LOCALIZATION localizedStringForKey:@"email"],[LOCALIZATION localizedStringForKey:@"phone"], nil];
    [contactAlert show];
    
}

-(IBAction)callAction
{

    [self call];
    

}
-(IBAction)sendSMSAction
{
    
    [self sendSMS];
    
    
}
-(IBAction)sendEmailAction
{
    
    [self sendEmail];
    
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView==contactAlert) {
         if(buttonIndex==1)
           [self sendSMS];
        else if (buttonIndex==2)
            [self sendEmail];
        else if(buttonIndex==3)
            [self call];
    }
}
-(void)sendEmail{
    [self sendEmailtoUser];
}



-(void)sendSMS{
    
    
          MFMessageComposeViewController *controller = [[MFMessageComposeViewController alloc] init];
        if([MFMessageComposeViewController canSendText])
        {
            NSMutableArray *toRecipients = [[NSMutableArray alloc]init];
            [toRecipients addObject:[[_response valueForKey:@"Property"] valueForKey:@"mobile"]];
            [controller setRecipients:(NSArray *)toRecipients];
            controller.messageComposeDelegate = self;
            [self presentViewController:controller animated:YES completion:^{
                
            }];
        }
    
}


- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
    
    if (result == MessageComposeResultCancelled)
        NSLog(@"Message cancelled");
    else if (result == MessageComposeResultSent)
        NSLog(@"Message sent");
    else
        NSLog(@"Message failed");
}

-(void)call{
    NSString *phoneNumber = [@"telprompt://" stringByAppendingString:[[_response valueForKey:@"Property"] valueForKey:@"mobile"]];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneNumber]];
}
-(void)sendEmailtoUser
{
    NSLog(@"%@",[[_response valueForKey:@"Property"] valueForKey:@"email"]);
    
    
    if ([MFMailComposeViewController canSendMail]) {
        
        MFMailComposeViewController *mailViewController = [[MFMailComposeViewController alloc] init];
        
        mailViewController.mailComposeDelegate = self;
        
        NSArray *usersTo = [NSArray arrayWithObject:(NSString *)[[_response valueForKey:@"Property"] valueForKey:@"email"]];
        
        [mailViewController setToRecipients:usersTo];
        
        [mailViewController setSubject:@""];
        
        [mailViewController setMessageBody:@"" isHTML:NO];
        
        [self presentViewController:mailViewController animated:YES completion:^{
            
        }];
        
    }
    
    
    
    
//    EmailViewController *detail=[[EmailViewController alloc]initWithNibName:@"EmailViewController" bundle:nil];
//    detail.details=[NSMutableDictionary dictionaryWithDictionary:self.response];
//    [self.navigationController pushViewController:detail animated:YES];
    
}
- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail sent");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail sent failure: %@", [error localizedDescription]);
            break;
        default:
            break;
    }
    [self dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark - FGalleryViewControllerDelegate Methods

- (IBAction)changeImage:(UIButton *)button {
    
    CATransition *transition = [CATransition animation];
    transition.duration = 0.5f;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;
    
   
    
    switch (button.tag) {
        case 1:{
            if(k < propertyImagesArray.count){
                    k++;
                transition.subtype = kCATransitionFromRight;
            }
            }
            break;
            
        case 2:
            if(k > 0){
                --k;
                transition.subtype = kCATransitionFromLeft;
            }
            break;
            
        default:
            break;
    }
    [_imgProperty sd_setImageWithURL:[NSURL URLWithString:[propertyImagesArray objectAtIndex:k]] placeholderImage:[UIImage imageNamed:@"home_placeholder.png"]];
    [_image_imagegallary sd_setImageWithURL:[NSURL URLWithString:[propertyImagesArray objectAtIndex:k]] placeholderImage:[UIImage imageNamed:@"home_placeholder.png"]];
    
    (k > 0)?([_button_previous_image setHidden:NO]):([_button_previous_image setHidden:YES]);
    (k > 0)?([_button_previous_imagegallary setHidden:NO]):([_button_previous_imagegallary setHidden:YES]);
    
    (k < propertyImagesArray.count-1)?([_button_next_image setHidden:NO]):([_button_next_image setHidden:YES]);
    (k < propertyImagesArray.count-1)?([_button_next_imagegallary setHidden:NO]):([_button_next_imagegallary setHidden:YES]);
    
    [_imgProperty.layer addAnimation:transition forKey:nil];
    [_image_imagegallary.layer addAnimation:transition forKey:nil];
}

- (IBAction)zoomoutFromGallery:(id)sender {
    [_view_imagegallary removeFromSuperview];
}

- (IBAction)zoomInGallery:(id)sender {
    CGFloat x,y,w,h;
    
    x = 0;
    y = 0;
    w = 320;
    h = self.view.frame.size.height;
    
    [self.view addSubview:_view_imagegallary];
    [_view_imagegallary setFrame:CGRectMake(x, y, w, h)];
    
}

- (IBAction)shareWith:(UIButton *)sender {
    switch (sender.tag) {
        case 1: [self shareWithFacebook]; break;
        case 2: [self shareWithTwitter]; break;
        case 3: [self shareWithGoogle]; break;
        default:
            break;
    }
}

- (IBAction)tweetOnTwitter:(id)sender {
    
    NSString * tweet_comment = [[_textview_twitter_sharing_comment.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]];
    
    if (tweet_comment.length <= 0) {
        alerttitle = @"Tweeter";
        alerterrormessage = @"Type your tweet";
        [[[UIAlertView alloc]initWithTitle:alerttitle message:alerterrormessage delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
        [_textview_twitter_sharing_comment becomeFirstResponder];
        return;
    }else{
        
        
    }
    
    [[FHSTwitterEngine sharedEngine] permanentlySetConsumerKey:TWITTER_CONSUMER_KEY andSecret:TWITTER_SECRET_KEY];
    [[FHSTwitterEngine sharedEngine]setDelegate:self];
    [[FHSTwitterEngine sharedEngine]loadAccessToken];
    
    NSData * tweet_image_data = UIImageJPEGRepresentation(_image_twitter_sharing_image.image, 1) ;
    UIViewController *loginController = [[FHSTwitterEngine sharedEngine]loginControllerWithCompletionHandler:^(BOOL success) {
        
        if (success) {
            NSLog(@"Login Success");
            NSString * username = [[[FHSTwitterEngine sharedEngine] getUserSettings] objectForKey:@"screen_name"];
            NSLog(@"User Info %@",username);
            
            alerttitle = @"Tweeter";
            id returned = [[FHSTwitterEngine sharedEngine]postTweet:tweet_comment withImageData:tweet_image_data];
            //id returned = [[FHSTwitterEngine sharedEngine]postTweet:@"iOS 8 Comming This fall"];//] withImageData:tweet_image_data];
            if ([returned isKindOfClass:[NSError class]]){
                NSError *error = (NSError *)returned;
                [NSString stringWithFormat:@"Error %ld",(long)error.code];
                //message = error.localizedDescription;
                //[self.view makeToast:[NSString stringWithFormat:@"%@",error]];
                alerterrormessage = @"Your tweet could not be posted\nTry Again";
                [[[UIAlertView alloc]initWithTitle:alerttitle message:alerterrormessage delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
            } else {
                NSLog(@"id retured Output : *****> %@",returned);
                alerterrormessage = @"Your tweet has been posted";
                [[[UIAlertView alloc]initWithTitle:alerttitle message:alerterrormessage delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
            }
        }else{
            NSLog(@"Login Failed");
            alerterrormessage = @"Your twitter login failed\nTry Again";
            [[[UIAlertView alloc]initWithTitle:alerttitle message:alerterrormessage delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
        }
     
        [self cancelTweet:nil];
    }];
    [self presentViewController:loginController animated:YES completion:nil];
}

- (IBAction)cancelTweet:(id)sender {
    isTweeting = NO;
    [UIView animateWithDuration:0.3 animations:^{
        _view_tweeter_view.alpha = 0.0;
    } completion:^(BOOL finished) {
        [_view_tweeter_view removeFromSuperview];
        [_textview_twitter_sharing_comment setText:@"< Tweet Here >"];
    }];
    
}
-(void)adjust{
    
    CGRect frame=self.view_socialsharing.frame;
    frame.origin.y=self.lblDescription.frame.origin.y+self.lblDescription.frame.size.height+10;
    self.view_socialsharing.frame=frame;
    
    if (!DELEGATE.isComingFromMyListing) {
        frame.origin.y = self.view_socialsharing.frame.origin.y + self.view_socialsharing.frame.size.height + 5;
    }
    self.btnContact.frame = frame;
    [self.scrollView setContentSize:CGSizeMake(320, _btnContact.frame.origin.y + _btnContact.frame.size.height+20)];
    
}
- (void) getAllInvitableFriends
{
    NSMutableArray *tempFriendsList =  [[NSMutableArray alloc] init];
    NSDictionary *limitParam = [NSDictionary dictionaryWithObjectsAndKeys:@"100", @"limit", nil];
    [self getAllInvitableFriendsFromFB:limitParam addInList:tempFriendsList];
}

- (void) getAllInvitableFriendsFromFB:(NSDictionary*)parameters
                            addInList:(NSMutableArray *)tempFriendsList
{
    [FBRequestConnection startWithGraphPath:@"/me/invitable_friends"
                                 parameters:parameters
                                 HTTPMethod:@"GET"
                          completionHandler:^(
                                              FBRequestConnection *connection,
                                              id result,
                                              NSError *error
                                              ) {
                              NSLog(@"error=%@",error);
                              
                              NSLog(@"result=%@",result);
                              
                              NSArray *friendArray = [result objectForKey:@"data"];
                              
                              [tempFriendsList addObjectsFromArray:friendArray];
                              
                              NSDictionary *paging = [result objectForKey:@"paging"];
                              NSString *next = nil;
                              next = [paging objectForKey:@"next"];
                              if(next != nil)
                              {
                                  NSDictionary *cursor = [paging objectForKey:@"cursors"];
                                  NSString *after = [cursor objectForKey:@"after"];
                                  //NSString *before = [cursor objectForKey:@"before"];
                                  NSDictionary *limitParam = [NSDictionary dictionaryWithObjectsAndKeys:
                                                              @"100", @"limit", after, @"after"
                                                              , nil
                                                              ];
                                  [self getAllInvitableFriendsFromFB:limitParam addInList:tempFriendsList];
                              }
                              else
                              {
                                  [self replaceGlobalListWithRecentData:tempFriendsList];
                              }
                          }];
}

- (void) replaceGlobalListWithRecentData:(NSMutableArray *)tempFriendsList
{
    // replace global from received list
    [m_invitableFriends removeAllObjects];
    [m_invitableFriends addObjectsFromArray:tempFriendsList];
    NSLog(@"friendsList = %d", [m_invitableFriends count]);
    
}

- (IBAction)editProperty:(id)sender {    
    DELEGATE.isAddingProperty = NO;
    AddPropertyViewController * apvc = [[AddPropertyViewController alloc]initWithNibName:NSStringFromClass([AddPropertyViewController class]) bundle:nil];
    apvc.property_detail_dictionary = [[NSMutableDictionary alloc]initWithDictionary:_response];
    [self.navigationController pushViewController:apvc animated:YES];
}

-(void)shareWithFacebook{
    FacebookviewController * facebook =[[FacebookviewController alloc]init];
    facebook.FBDelegate=self;
    
    NSString * name = [NSString stringWithFormat:@"%@",[[_response valueForKey:@"Property"] valueForKey:@"title"]];
    NSString * caption = @"Alert";
    NSString * description = [NSString stringWithFormat:@"%@",[[_response valueForKey:@"Property"] valueForKey:@"description"]];
    NSString * titlelink = @"http://www.Alert.com";
    NSString * imageurl = [NSString stringWithFormat:@"%@%@",IMAGE_PATH,[[_response valueForKey:@"Property"] valueForKey:@"image"]];

    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   name,        @"name",
                                   caption,     @"caption",
                                   description, @"description",
                                   titlelink,   @"link",
                                   imageurl,    @"picture",
                                   nil];
    [facebook shareLinkOnFacebookWithDictionary:params];
}

-(void)shareWithTwitter{
    
    xtw = self.view.frame.origin.x;
    ytw = self.view.frame.origin.y;
    wtw = self.view.frame.size.width;
    htw = self.view.frame.size.height;
    
    NSString * title = [NSString stringWithFormat:@"%@ at %@ for %@ USD ",[[_response valueForKey:@"Property"] valueForKey:@"title"],[[_response valueForKey:@"Property"] valueForKey:@"location"],[[_response valueForKey:@"Property"] valueForKey:@"price"]];
    
    
    NSString * tweettext = title;
    if (tweettext.length>140) {
        _textview_twitter_sharing_comment.text = [tweettext substringToIndex:139];
    }else{
        _textview_twitter_sharing_comment.text = tweettext;
    }
    
    [_label_tweet_limit setText:[NSString stringWithFormat:@"%u",140 - _textview_twitter_sharing_comment.text.length]];
    
    [_image_twitter_sharing_image setImage:_imgProperty.image];
    
    [self.view addSubview:_view_tweeter_view];
    [_view_tweeter_view setFrame:CGRectMake(xtw, ytw, wtw, htw)];
    _view_tweeter_view.alpha = 0.0;
    [UIView animateWithDuration:0.4 animations:^{
        _view_tweeter_view.alpha = 1.0;
    }];
    
    isTweeting = YES;

    
}





/************************************************************************************/
#pragma UITextview delegate methods
/************************************************************************************/

- (void)textViewDidBeginEditing:(UITextView *)textView{
    
    [textView setText: [[_textview_twitter_sharing_comment.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]]];
}

- (void)textViewDidEndEditing:(UITextView *)textView{
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }else{
        int charlength = _textview_twitter_sharing_comment.text.length;
        if (charlength > 139) {
            return NO;
        }else{
            [_label_tweet_limit setText:[NSString stringWithFormat:@"%d",140-charlength]];
        }
    }

    return YES;
}

- (void)finishedSharingWithError:(NSError *)error{
    [UIAlertHelper showAlert:[LOCALIZATION localizedStringForKey:@"shared"]];
    
}
- (void)finishedSharing:(BOOL)shared{
    [UIAlertHelper showAlert:[LOCALIZATION localizedStringForKey:@"failed"]];
}
- (NSString *)loadAccessToken{
    return @"";
}
- (void)storeAccessToken:(NSString *)accessToken{
    
}
//Localization stuffs
-(void)localization{
    [self.lblTitleMain setText:[LOCALIZATION localizedStringForKey:@"propertydetails"]];
    [self.lblLocationCaption setText:[LOCALIZATION localizedStringForKey:@"location"]];
    [self.lblTypeCaption setText:[LOCALIZATION localizedStringForKey:@"type"]];
    [self.lblCostCaption setText:[LOCALIZATION localizedStringForKey:@"price"]];
    [self.lblZoningCaption setText:[LOCALIZATION localizedStringForKey:@"zoninig"]];
    [self.lblDescriptionCaption setText:[LOCALIZATION localizedStringForKey:@"description"]];
    [self.lblShareWithCaption setText:[LOCALIZATION localizedStringForKey:@"sharewith"]];
    
    [self adjustAlignment];
}
-(void)adjustAlignment{
   
   
}
@end
