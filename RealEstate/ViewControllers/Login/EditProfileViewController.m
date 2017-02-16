//
//  EditProfileViewController.m
//  RealEstate
//
//  Created by Roman Bigun on 21/06/14.
//  Copyright (c) 2014 Roman Bigun All rights reserved.
//

#import "EditProfileViewController.h"
#import "MFSideMenu.h"
#import "UIAlertHelper.h"
#import "UIImageView+WebCache.h"
#import "FeedViewController.h"


@interface EditProfileViewController ()

@end

@implementation EditProfileViewController{
    UIAlertView *photoAlert;
    UIToolbar *mypickerToolbar;
    NSMutableArray * keyboardfieldsArray;
    NSString *loginEmail;
    NSString *loginPassword;
    UIAlertView *update;
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
    self.mc=[[ModelClass alloc]init];
    self.mc.delegate=self;
    
    [self setTextFieldFonts];
    
    [_ImgProfilePic.layer setCornerRadius:53.0f];
    [_ImgProfilePic.layer setMasksToBounds:YES];
    //Call bskeyboard settings
   
    NSDictionary *userDetail=[NSDictionary dictionaryWithDictionary:[[NSUserDefaults standardUserDefaults] valueForKey:@"user"]];
    if ([[userDetail valueForKey:@"login_type"] isEqualToString:@"R"]) {
        [self bsKeyboardSettingRegular];
        [self.viewscroll addSubview:self.viewRegular];
        [self.viewscroll setContentSize:CGSizeMake(320, self.viewRegular.frame.size.height+30)];
        [self preLoadDataRegular];
    }else{
        [self.viewscroll addSubview:self.viewSocial];
        [self.viewscroll setContentSize:self.viewSocial.frame.size];
        [self bsKeyboardSettingSocial];
        [self preLoadSocial];
    }
}
-(void)viewWillAppear:(BOOL)animated{
    [self localization];
}
-(void)preLoadDataRegular{
    
    NSDictionary *userDetail=[NSDictionary dictionaryWithDictionary:[[NSUserDefaults standardUserDefaults] valueForKey:@"user"]];
    _txtFirstName.text=[userDetail valueForKey:@"firstname"];
    _txtLastName.text=[userDetail valueForKey:@"lastname"];
    _txtEmail.text=[userDetail valueForKey:@"email"];
    _txtPhoneNumber.text=[userDetail valueForKey:@"phone"];
    _txtAddress.text=[userDetail valueForKey:@"address"];
     _txtState.text=[userDetail valueForKey:@"state"];
     _txtCity.text=[userDetail valueForKey:@"city"];
     _txtCountry.text=[userDetail valueForKey:@"country"];
    [_ImgProfilePic sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMAGE_PATH,[userDetail valueForKey:@"image"]]]];
    
    
}
-(void)preLoadSocial{
    NSDictionary *userDetail=[NSDictionary dictionaryWithDictionary:[[NSUserDefaults standardUserDefaults] valueForKey:@"user"]];
    
    _txtSocialPhone.text=[userDetail valueForKey:@"phone"];
    _txtSocialAddress.text=[userDetail valueForKey:@"address"];
    _txtSocialState.text=[userDetail valueForKey:@"state"];
    _txtSocialCity.text=[userDetail valueForKey:@"city"];
    _txtSocialCountry.text=[userDetail valueForKey:@"country"];
    [_ImgProfilePic sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[userDetail valueForKey:@"image"]]]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)regularSubmitClicked:(id)sender {
    [self.view endEditing:YES];
    [self validateInputes];
}

- (IBAction)socialSubmitClicked:(id)sender {
    [self.view endEditing:YES];
    [self validateInputsSocial];
}

- (IBAction)backBtnClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
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
//BS keyboard settings
-(void)bsKeyboardSettingRegular{
    
    keyboardfieldsArray = [NSMutableArray arrayWithObjects:
                           _txtFirstName,
                           _txtLastName,
                           _txtEmail,
                           _txtPassword,
                           _txtConfirmPassword,
                           _txtPhoneNumber,
                           _txtAddress,
                           _txtCity,
                           _txtState,
                           _txtCountry,
                           nil];
   	
    [self setKeyboardControls:[[BSKeyboardControls alloc] initWithFields:keyboardfieldsArray]];
    [self.keyboardControls setDelegate:self];
}
-(void)bsKeyboardSettingSocial{
    
    keyboardfieldsArray = [NSMutableArray arrayWithObjects:
                           _txtSocialPhone,
                           _txtSocialAddress,
                           _txtSocialCity,
                           _txtSocialState,
                           _txtSocialCountry,
                           nil];
   	
    [self setKeyboardControls:[[BSKeyboardControls alloc] initWithFields:keyboardfieldsArray]];
    [self.keyboardControls setDelegate:self];
}

- (void)keyboardControls:(BSKeyboardControls *)keyboardControls selectedField:(UIView *)field inDirection:(BSKeyboardControlsDirection)direction {
}


- (void)keyboardControlsDonePressed:(BSKeyboardControls *)keyboardControls{
    [self.view endEditing:YES];
}
//Textfield delegate methods
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    [self.keyboardControls setActiveField:textField];
}
-(void)textFieldDidEndEditing:(UITextField *)textField{
    [self.keyboardControls setActiveField:textField];
}
//Set text for textfields
-(void)setTextFieldFonts{
    [_txtFirstName setFont:TextFontLight(18)];
    [_txtLastName setFont:TextFontLight(18)];
    [_txtEmail setFont:TextFontLight(18)];
    [_txtPassword setFont:TextFontLight(18)];
    [_txtConfirmPassword setFont:TextFontLight(18)];
    [_txtPhoneNumber setFont:TextFontLight(18)];
    [_txtAddress setFont:TextFontLight(18)];
    [_txtCity setFont:TextFontLight(18)];
    [_txtState setFont:TextFontLight(18)];
    [_txtCountry setFont:TextFontLight(18)];
    [_txtAddress setFont:TextFontLight(18)];
    [_txtSocialAddress setFont:TextFontLight(18)];
    [_txtSocialCity setFont:TextFontLight(18)];
    [_txtSocialState setFont:TextFontLight(18)];
    [_txtSocialCountry setFont:TextFontLight(18)];
    [_txtSocialPhone setFont:TextFontLight(18)];
    [_btnSocialSubmit.titleLabel setFont:TextFont(18)];
    [_btnSubmit.titleLabel setFont:TextFont(18)];
    
}
//Take picture stuffs

//Alert view delgate method
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView == photoAlert) {
        if (buttonIndex==1) {
            [self openLibrary];
        }else if(buttonIndex==2)
            [self openCamera];
    }
    if (alertView==update) {
        
        FeedViewController *detail=[[FeedViewController alloc]initWithNibName:@"FeedViewController" bundle:nil];
        UINavigationController *navigationController = self.menuContainerViewController.centerViewController;
        NSArray *controllers = [NSArray arrayWithObject:detail];
        navigationController.viewControllers = controllers;
        [self.menuContainerViewController setMenuState:MFSideMenuStateClosed];
    }
}
-(void)openLibrary{
    UIImagePickerController   *pickerController = [[UIImagePickerController alloc]init];
    pickerController.delegate = self;
    pickerController.allowsEditing = YES;
    pickerController.sourceType =UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:pickerController animated:YES completion:nil];
}
-(void)openCamera{
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"EpicDelivery" message:@"Camera not available!" delegate:Nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
        return;
    }
    UIImagePickerController   *pickerController = [[UIImagePickerController alloc]init];
    pickerController.delegate = self;
    pickerController.allowsEditing = YES;
    pickerController.sourceType =UIImagePickerControllerSourceTypeCamera;
    [self presentViewController:pickerController animated:YES completion:nil];
    
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo{
    self.ImgProfilePic.image=image;
    [picker dismissModalViewControllerAnimated:YES];
}

//Action methods
- (IBAction)takePhotoClicked:(id)sender {
    photoAlert=[[UIAlertView alloc]initWithTitle:@"Alert" message:@"Select image via ?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Library",@"Camera", nil];
    [photoAlert show];
    
}

//Validate email method
- (BOOL) validateEmail: (NSString *)candidate {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    
    return [emailTest evaluateWithObject:candidate];
}
//Api call methods

- (void)regiter:(NSString *)firstname
       lastname:(NSString*)lastname
          email:(NSString*)email
       username:(NSString*)username
       password:(NSString*)password
         mobile:(NSString*)mobile
           city:(NSString*)city
          state:(NSString*)state
        country:(NSString*)country
        address:(NSString*)address
      device_id:(NSString*)device_id
          image:(UIImage*)image
         userid:(NSString*)userid
  is_socialuser:(NSString*)is_socialuser{
    
    loginEmail=[NSString stringWithString:email];
    loginPassword=[NSString stringWithString:password];
    
    [self.mc regiter:firstname lastname:lastname email:email username:username password:password mobile:mobile city:city state:state country:country address:address device_id:device_id userid:userid image:nil is_socialuser:is_socialuser selector:@selector(regiterFinished:)];
}

-(void)regiterFinished:(NSDictionary*)response{
    NSLog(@"Register view controller %@",response);
    if ([[response valueForKey:@"successful"] isEqualToString:@"true"]) {
        update=[[UIAlertView alloc]initWithTitle:@"Alert" message:[response valueForKey:@"message"] delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [update show];
        [[NSUserDefaults standardUserDefaults]setValue:[response valueForKey:@"User"] forKey:@"user"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"userlogin" object:self];
       
    }else{
        [UIAlertHelper showAlert:[response valueForKey:@"message"]];
    }
}

-(void)validateInputes{
    
    if (self.txtFirstName.text.length<1 ||[DELEGATE trimWhiteSpaces:self.txtFirstName.text].length<1) {
        [UIAlertHelper showAlert:[LOCALIZATION localizedStringForKey:@"firstname"]];
        return;
    }else if(self.txtLastName.text.length<1 ||[DELEGATE trimWhiteSpaces:self.txtLastName.text].length<1){
        [UIAlertHelper showAlert:[LOCALIZATION localizedStringForKey:@"lastname"]];
        return;
        
    }else if (self.txtEmail.text.length<1 ||[DELEGATE trimWhiteSpaces:self.txtEmail.text].length<1) {
        [UIAlertHelper showAlert:[LOCALIZATION localizedStringForKey:@"enteremail"]];
        return;
    }else if (![self validateEmail:[self.txtEmail.text stringByTrimmingCharactersInSet:
                                    [NSCharacterSet whitespaceAndNewlineCharacterSet]]]) {
        [UIAlertHelper showAlert:[LOCALIZATION localizedStringForKey:@"entervalidemail"]];
        return;
        
    }else if(self.txtPhoneNumber.text.length<1 ||[DELEGATE trimWhiteSpaces:self.txtPhoneNumber.text].length<1){
        [UIAlertHelper showAlert:[LOCALIZATION localizedStringForKey:@"enterphonenumber"]];
        return;
    }
    //Call register api
    [self regiter:[DELEGATE trimWhiteSpaces:self.txtFirstName.text]
         lastname:[DELEGATE trimWhiteSpaces:self.txtLastName.text]
            email:[DELEGATE trimWhiteSpaces:self.txtEmail.text]
         username:@""
         password:@""
           mobile:[DELEGATE trimWhiteSpaces:self.txtPhoneNumber.text]
             city:[DELEGATE trimWhiteSpaces:self.txtCity.text]
            state:@""
          country:[DELEGATE trimWhiteSpaces:self.txtCountry.text]
          address:[DELEGATE trimWhiteSpaces:self.txtAddress.text]
        device_id:@""
            image:self.ImgProfilePic.image     
           userid:[[[NSUserDefaults standardUserDefaults] valueForKey:@"user"] valueForKey:@"userid"] is_socialuser:@"N"];
    
}
-(void)validateInputsSocial{
    
    //Call register api
    [self regiter:@""
         lastname:@""
            email:@""
         username:@""
         password:@""
           mobile:[DELEGATE trimWhiteSpaces:self.txtSocialPhone.text]
             city:[DELEGATE trimWhiteSpaces:self.txtSocialCity.text]
            state:@""
          country:[DELEGATE trimWhiteSpaces:self.txtSocialCountry.text]
          address:[DELEGATE trimWhiteSpaces:self.txtSocialAddress.text]
        device_id:@""
            image:nil
           userid:[[[NSUserDefaults standardUserDefaults] valueForKey:@"user"] valueForKey:@"userid"] is_socialuser:@"Y"];

}

//Localization stuffs
-(void)localization{
    [self.lblTitle setText:[LOCALIZATION localizedStringForKey:@"editprofile"]];
    [_btnSocialSubmit setTitle:[LOCALIZATION localizedStringForKey:@"submit"] forState:UIControlStateNormal];
    _txtFirstName.placeholder=[LOCALIZATION localizedStringForKey:@"firstname"];
    _txtLastName.placeholder=[LOCALIZATION localizedStringForKey:@"lastname"];
    _txtEmail.placeholder=[LOCALIZATION localizedStringForKey:@"email"];
    _txtPassword.placeholder=[LOCALIZATION localizedStringForKey:@"password"];
    _txtConfirmPassword.placeholder=[LOCALIZATION localizedStringForKey:@"confirmpassword"];
    _txtPhoneNumber.placeholder=[LOCALIZATION localizedStringForKey:@"phonenumber"];
    _txtAddress.placeholder=[LOCALIZATION localizedStringForKey:@"address"];
    _txtCity.placeholder=[LOCALIZATION localizedStringForKey:@"city"];
    _txtCountry.placeholder=[LOCALIZATION localizedStringForKey:@"country"];
    _txtSocialPhone.placeholder=[LOCALIZATION localizedStringForKey:@"phonenumber"];
    _txtSocialAddress.placeholder=[LOCALIZATION localizedStringForKey:@"address"];
    _txtSocialCity.placeholder=[LOCALIZATION localizedStringForKey:@"city"];
    [_btnSubmit setTitle:[LOCALIZATION localizedStringForKey:@"submit"] forState:UIControlStateNormal];
    [_regularSubmit setTitle:[LOCALIZATION localizedStringForKey:@"submit"] forState:UIControlStateNormal];

    _txtSocialCountry.placeholder=[LOCALIZATION localizedStringForKey:@"country"];;
    [self adjustAlignment];
}
-(void)adjustAlignment{
    
    CGRect frame;
    if ([[USER_DEFAULTS valueForKey:@"localization"] isEqualToString:@"AR"]) {
        
        _txtFirstName.textAlignment=NSTextAlignmentRight;
        _txtLastName.textAlignment=NSTextAlignmentRight;
        _txtEmail.textAlignment=NSTextAlignmentRight;
        _txtPassword.textAlignment=NSTextAlignmentRight;
        _txtConfirmPassword.textAlignment=NSTextAlignmentRight;
        _txtPhoneNumber.textAlignment=NSTextAlignmentRight;
        _txtAddress.textAlignment=NSTextAlignmentRight;
        _txtCity.textAlignment=NSTextAlignmentRight;
        _txtCountry.textAlignment=NSTextAlignmentRight;
        _txtSocialPhone.textAlignment=NSTextAlignmentRight;
        _txtSocialAddress.textAlignment=NSTextAlignmentRight;
        _txtSocialCity.textAlignment=NSTextAlignmentRight;
        
        frame=_btnMenu.frame;
        frame.origin.x=frame.origin.x=240;
        _btnMenu.frame=frame;
        
        
    }else{
        
        _txtFirstName.textAlignment=NSTextAlignmentLeft;
        _txtLastName.textAlignment=NSTextAlignmentLeft;
        _txtEmail.textAlignment=NSTextAlignmentLeft;
        _txtPassword.textAlignment=NSTextAlignmentLeft;
        _txtConfirmPassword.textAlignment=NSTextAlignmentLeft;
        _txtPhoneNumber.textAlignment=NSTextAlignmentLeft;
        _txtAddress.textAlignment=NSTextAlignmentLeft;
        _txtCity.textAlignment=NSTextAlignmentLeft;
        _txtCountry.textAlignment=NSTextAlignmentLeft;
        _txtSocialPhone.textAlignment=NSTextAlignmentLeft;
        _txtSocialAddress.textAlignment=NSTextAlignmentLeft;
        _txtSocialCity.textAlignment=NSTextAlignmentLeft;
        
        frame=_btnMenu.frame;
        frame.origin.x=frame.origin.x=-20;
        _btnMenu.frame=frame;
    }
}

@end
