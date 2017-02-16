//
//  LoginViewController.m
//  RealEstate
//
//  Created by Roman Bigun on 05/06/14.
//  Copyright (c) 2014 Roman Bigun All rights reserved.
//

#import "LoginViewController.h"
#import "UIAlertHelper.h"
#import "RegisterViewController.h"
#import "FacebookviewController.h"
#import "FeedViewController.h"
#import "MFSideMenu.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

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
    self.mc=[[ModelClass alloc]init];
    self.mc.delegate=self;
    
    [[FHSTwitterEngine sharedEngine] permanentlySetConsumerKey:TWITTER_CONSUMER_KEY andSecret:TWITTER_SECRET_KEY];
    [[FHSTwitterEngine sharedEngine] setDelegate:self];
    [[FHSTwitterEngine sharedEngine] loadAccessToken];
    UIColor *color = [UIColor colorWithRed:145.0/255.0 green:145.0/255.0 blue:145.0/255.0 alpha:1.0 ];
    _txtUserName.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Email" attributes:@{NSForegroundColorAttributeName: color}];
    _txtUserName.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Password" attributes:@{NSForegroundColorAttributeName: color}];
    
    [_scroll_loginform setContentSize:CGSizeMake(320, 555)];
    
    [DELEGATE addIntegration:self];
}
-(void)viewWillAppear:(BOOL)animated{
    [self localization];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)loginClicked:(id)sender {
    
    if (self.txtUserName.text.length<1 ||[DELEGATE trimWhiteSpaces:self.txtUserName.text].length<1) {
        [UIAlertHelper showAlert:[LOCALIZATION localizedStringForKey:@"enteremail"]];
        [_txtUserName becomeFirstResponder];
        return;
    }else if (![self validateEmail:[self.txtUserName.text stringByTrimmingCharactersInSet:
                                    [NSCharacterSet whitespaceAndNewlineCharacterSet]]]) {
        [UIAlertHelper showAlert:[LOCALIZATION localizedStringForKey:@"entervalidemail"]];
        return;
        
    }else if(self.txtPassword.text.length<1 ||[DELEGATE trimWhiteSpaces:self.txtPassword.text].length<1){
        [UIAlertHelper showAlert:[LOCALIZATION localizedStringForKey:@"enterpassword"]];
        [_txtPassword becomeFirstResponder];
        return;
    }

    if (self.txtUserName.isFirstResponder) {
        [self.txtUserName resignFirstResponder];
    }else if (self.txtPassword.isFirstResponder){
        [self.txtPassword resignFirstResponder];
    }
    
    [self login:[DELEGATE trimWhiteSpaces:self.txtUserName.text] password:[DELEGATE trimWhiteSpaces:self.txtPassword.text] is_social:@"N" social_type:@"" social_id:@""];
}

- (IBAction)registerClicked:(id)sender {
    self.txtPassword.text=@"";
    self.txtUserName.text=@"";
    if (self.txtUserName.isFirstResponder) {
        [self.txtUserName resignFirstResponder];
    }else if (self.txtPassword.isFirstResponder){
        [self.txtPassword resignFirstResponder];
    }
    RegisterViewController *detail=[[RegisterViewController alloc]initWithNibName:@"RegisterViewController" bundle:nil];
    [self.navigationController pushViewController:detail animated:YES];
}
- (IBAction)fbLoginClicked:(id)sender {
    [self fbLogin];
}
- (IBAction)twitterLoginClicked:(id)sender {
    [self twitterLogin];
}

- (IBAction)menuCLicked:(id)sender {
    
    if ([[USER_DEFAULTS valueForKey:@"localization"] isEqualToString:@"AR"]) {
        [self.menuContainerViewController toggleRightSideMenuCompletion:^{
            
        }];
    }else{
        [self.menuContainerViewController toggleLeftSideMenuCompletion:^{
            
        }];
    }
    
}

//Text field delegates
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
   
    if (_txtUserName.isFirstResponder) {
        [_txtPassword becomeFirstResponder];
    }else if (_txtPassword.isFirstResponder){
        [_txtPassword resignFirstResponder];
    }
    return YES;
}
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    [self animateTextField: textField up: YES];
}
-(void)textFieldDidEndEditing:(UITextField *)textField{
    [self animateTextField: textField up: NO];
}
- (void)animateTextField: (UITextField*)textField up: (BOOL) up
{
    const int movementDistance = 150; // tweak as needed
    const float movementDuration = 0.3f; // tweak as needed
    
    int movement = (up ? -movementDistance : movementDistance);
    
    [UIView beginAnimations: @"anim" context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: movementDuration];
    self.view.frame = CGRectOffset(self.view.frame, 0, movement);
    [UIView commitAnimations];
}
//Api call functions
-(void)login:(NSString *)email
    password:(NSString*)password
   is_social:(NSString*)is_social
 social_type:(NSString*)social_type
   social_id:(NSString*)social_id{

    [self.mc userLogin:email password:password is_social:is_social social_type:social_type social_id:social_id selector:@selector(loginFinished:)];
}
-(void)loginFinished:(NSDictionary*)response{
    
    if ([[response valueForKey:@"successful"] isEqualToString:@"true"]) {
        [[NSUserDefaults standardUserDefaults]setValue:[response valueForKey:@"User"] forKey:@"user"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"userlogin" object:self];
        
        if (DELEGATE.isAddingProperty) {
            AddPropertyViewController * addproperty = [[AddPropertyViewController alloc]initWithNibName:NSStringFromClass([AddPropertyViewController class]) bundle:nil];
            [self.navigationController pushViewController:addproperty animated:YES];
        }else{
            FeedViewController *detail=[[FeedViewController alloc]initWithNibName:@"FeedViewController" bundle:nil];
            [self.navigationController pushViewController:detail animated:YES];
        }
        
    }else{
        self.txtPassword.text=@"";
        self.txtUserName.text=@"";
        [UIAlertHelper showAlert:[response valueForKey:@"message"]];
    }
}
-(void)fbLogin{
    FacebookviewController *facebook =[[FacebookviewController alloc]init];
    facebook.FBDelegate=self;
    [facebook getFacebookUserInfo:@selector(MyfbInfo:)];
}
-(void)MyfbInfo:(NSDictionary*)resposne{
    NSLog(@"MyfbInfo---->>> %@",resposne);
    [self socialLogin:@"F" social_data:[resposne JSONRepresentation]];
}
//Login with social
-(void)socialLogin:(NSString*)social_type social_data:(NSString*)social_data{
    [self.mc socialLogin:social_type social_data:social_data selector:@selector(socialLoginFinish:)];
}
-(void)socialLoginFinish:(NSDictionary*)response{
    NSLog(@"Login view controller %@",response);
    if ([[response valueForKey:@"successful"] isEqualToString:@"true"]) {
        [[NSUserDefaults standardUserDefaults]setValue:[response valueForKey:@"User"] forKey:@"user"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"userlogin" object:self];
        DELEGATE.isFacebookLogin = YES;
        
        FeedViewController *detail=[[FeedViewController alloc]initWithNibName:@"FeedViewController" bundle:nil];
        [self.navigationController pushViewController:detail animated:YES];
        
    }else{
        self.txtPassword.text=@"";
        self.txtUserName.text=@"";
        [UIAlertHelper showAlert:[response valueForKey:@"message"]];
    }
}
-(void)twitterLogin{
    UIViewController *loginController = [[FHSTwitterEngine sharedEngine]loginControllerWithCompletionHandler:^(BOOL success) {
        NSLog(success?@"L0L success":@"O noes!!! Loggen faylur!!!");
        [self listResults];
        
    }];
    [self presentViewController:loginController animated:YES completion:nil];
}
- (void)listResults {

    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    // the following line contains a FHSTwitterEngine method wich do the search.
    NSDictionary *temp = [[NSDictionary alloc]initWithDictionary:[[FHSTwitterEngine sharedEngine]verifyCredentials]];
    
    NSString *email =[NSString stringWithFormat:@"%@@twitter.com",[temp valueForKey:@"screen_name"]];
    NSLog(@"email id is:%@",email);
    NSLog(@"Twitter: %@",temp);
    NSLog(@"Json %@",[temp JSONRepresentation]);
    [self socialLogin:@"T" social_data:[temp JSONRepresentation]];
    
}

- (void)storeAccessToken:(NSString *)accessToken {
    [[NSUserDefaults standardUserDefaults]setObject:accessToken forKey:@"SavedAccessHTTPBody"];
}

- (NSString *)loadAccessToken
{
    return [[NSUserDefaults standardUserDefaults]objectForKey:@"SavedAccessHTTPBody"];
}
//Validate email method
- (BOOL) validateEmail: (NSString *)candidate {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    
    return [emailTest evaluateWithObject:candidate];
}
//Localization stuffs
-(void)localization{
//    [self.lblTitle setText:[LOCALIZATION localizedStringForKey:@"login"]];
//    [self.btnLogin setTitle:[LOCALIZATION localizedStringForKey:@"login"] forState:UIControlStateNormal];
//    [self.btnRegister setTitle:[LOCALIZATION localizedStringForKey:@"register"] forState:UIControlStateNormal];
       _txtUserName.placeholder=@"Email";
       _txtPassword.placeholder=@"Password";
//    [self adjustAlignment];
}

-(void)adjustAlignment{
    
    CGRect frame;
    if ([[USER_DEFAULTS valueForKey:@"localization"] isEqualToString:@"AR"]) {
        _txtPassword.textAlignment=NSTextAlignmentRight;
        _txtUserName.textAlignment=NSTextAlignmentRight;
        _imgViewUserBg.image=[UIImage imageNamed:@"usrTxtBgR.png"];
        _imgViewPassBg.image=[UIImage imageNamed:@"passTxtBgR.png"];
        
        frame=_txtUserName.frame;
        frame.origin.x=frame.origin.x=20;
        _txtUserName.frame=frame;
        
        frame=_txtPassword.frame;
        frame.origin.x=frame.origin.x=20;
        _txtPassword.frame=frame;
        
        
        frame=_btnMenu.frame;
        frame.origin.x=frame.origin.x=240;
        _btnMenu.frame=frame;
        
        
        
    }else{
        _txtPassword.textAlignment=NSTextAlignmentLeft;
        _txtUserName.textAlignment=NSTextAlignmentLeft;
        _imgViewUserBg.image=[UIImage imageNamed:@"usrTxtBg.png"];
        _imgViewPassBg.image=[UIImage imageNamed:@"passTxtBg.png"];
        
        frame=_txtUserName.frame;
        frame.origin.x=frame.origin.x=70;
        _txtUserName.frame=frame;
        
        frame=_txtPassword.frame;
        frame.origin.x=frame.origin.x=70;
        _txtPassword.frame=frame;
        
        frame=_btnMenu.frame;
        frame.origin.x=frame.origin.x=-20;
        _btnMenu.frame=frame;
    }
}

@end
