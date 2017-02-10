//
//  RegisterViewController.m
//  RealEstate
//
//  Created by macmini7 on 05/06/14.
//  Copyright (c) 2014 macmini7. All rights reserved.
//

#import "RegisterViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "UIAlertHelper.h"
#import "FeedViewController.h"


@interface RegisterViewController ()

@end

@implementation RegisterViewController{
    UIAlertView *photoAlert;
    UIToolbar *mypickerToolbar;
    NSMutableArray * keyboardfieldsArray;
    NSString *loginEmail;
    NSString *loginPassword;
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
    
    self.mc=[[ModelClass alloc]init];
    self.mc.delegate=self;
    
    [self setTextFieldFonts];
    
    [_ImgProfilePic.layer setCornerRadius:53.0f];
    [_ImgProfilePic.layer setMasksToBounds:YES];
    
    //Set contentsize of scroll according to container view
    [self.viewscroll addSubview:self.viewContainer];
    [self.viewscroll setContentSize:CGSizeMake(320, self.viewContainer.frame.size.height + 44) ];
    
    
    //Call bskeyboard settings
    [self bsKeyboardSetting];
    [DELEGATE addIntegration:self];
}
-(void)viewWillAppear:(BOOL)animated{
    [self localization];
}
//Toolbar done button action
-(void)pickerDoneClicked{
    [self.txtPhoneNumber resignFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    photoAlert=[[UIAlertView alloc]initWithTitle:@"Erminesoft" message:@"Select image via ?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Library",@"Camera", nil];
    [photoAlert show];

}
- (IBAction)submitClicked:(id)sender {
    [self validateInputes];
}

- (IBAction)backBtnClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
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
         userid:(NSString*)userid{
    
    loginEmail=[NSString stringWithString:email];
    loginPassword=[NSString stringWithString:password];
    
    [self.mc regiter:firstname lastname:lastname email:email username:username password:password mobile:mobile city:city state:state country:country address:address device_id:device_id userid:@"" image:nil is_socialuser:@"N"  selector:@selector(regiterFinished:)];
}
-(void)regiterFinished:(NSDictionary*)response{
    if ([[response valueForKey:@"successful"] isEqualToString:@"true"]) {
        [self login:loginEmail password:loginPassword is_social:@"N" social_type:@"" social_id:@""];
    }else{
        [UIAlertHelper showAlert:[response valueForKey:@"message"]];
    }
}

-(void)validateInputes{
    
    if (self.txtFirstName.text.length<1 ||[DELEGATE trimWhiteSpaces:self.txtFirstName.text].length<1) {
        [UIAlertHelper showAlert:[LOCALIZATION localizedStringForKey:@"enterfirstname"]];
        return;
    }else if(self.txtLastName.text.length<1 ||[DELEGATE trimWhiteSpaces:self.txtLastName.text].length<1){
        [UIAlertHelper showAlert:[LOCALIZATION localizedStringForKey:@"enterlastname"]];
        return;
        
    }else if (self.txtEmail.text.length<1 ||[DELEGATE trimWhiteSpaces:self.txtEmail.text].length<1) {
        [UIAlertHelper showAlert:[LOCALIZATION localizedStringForKey:@"enteremail"]];
        return;
    }else if (![self validateEmail:[self.txtEmail.text stringByTrimmingCharactersInSet:
                                    [NSCharacterSet whitespaceAndNewlineCharacterSet]]]) {
        [UIAlertHelper showAlert:[LOCALIZATION localizedStringForKey:@"entervalidemail"]];
        return;
        
    }else if(self.txtPassword.text.length<1 ||[DELEGATE trimWhiteSpaces:self.txtPassword.text].length<1){
        [UIAlertHelper showAlert:[LOCALIZATION localizedStringForKey:@"enterpassword"]];
        return;
        
    }else if(self.txtConfirmPassword.text.length<1 ||[DELEGATE trimWhiteSpaces:self.txtConfirmPassword.text].length<1){
        [UIAlertHelper showAlert:[LOCALIZATION localizedStringForKey:@"enterphonenumber"]];
        return;
        
    }else if(self.txtPhoneNumber.text.length<1 ||[DELEGATE trimWhiteSpaces:self.txtPhoneNumber.text].length<1){
        [UIAlertHelper showAlert:[LOCALIZATION localizedStringForKey:@"register"]];
        return;
        
    }else if (![[self.txtPassword.text stringByTrimmingCharactersInSet:
                 [NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:[self.txtConfirmPassword.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]]) {
        [UIAlertHelper showAlert:[LOCALIZATION localizedStringForKey:@"passowrdmissmatch"]];
        self.txtPassword.text=@"";
        self.txtConfirmPassword.text=@"";
        return;
    }
    
    //Call register api
    [self regiter:[DELEGATE trimWhiteSpaces:self.txtFirstName.text]
         lastname:[DELEGATE trimWhiteSpaces:self.txtLastName.text]
            email:[DELEGATE trimWhiteSpaces:self.txtEmail.text]
         username:@""
         password:[DELEGATE trimWhiteSpaces:self.txtPassword.text]
           mobile:[DELEGATE trimWhiteSpaces:self.txtPhoneNumber.text]
             city:[DELEGATE trimWhiteSpaces:self.txtCity.text]
            state:@""
          country:[DELEGATE trimWhiteSpaces:self.txtCountry.text]
          address:[DELEGATE trimWhiteSpaces:self.txtAddress.text]
        device_id:@""
            image:self.ImgProfilePic.image userid:@""];
}

//BS keyboard settings
-(void)bsKeyboardSetting{
    keyboardfieldsArray = [NSMutableArray arrayWithObjects:
                           _txtFirstName,
                           _txtLastName,
                           _txtEmail,
                           _txtPassword,
                           _txtConfirmPassword,
                           _txtPhoneNumber,
                           _txtAddress,
                           _txtCity,
                           _txtCountry,
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
   // [_txtState setFont:TextFontLight(18)];
    [_txtCountry setFont:TextFontLight(18)];
    [_btnSubmit.titleLabel setFont:TextFont(18)];
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
        FeedViewController *detail=[[FeedViewController alloc]initWithNibName:@"FeedViewController" bundle:nil];
        [self.navigationController pushViewController:detail animated:YES];
    }else{
        [UIAlertHelper showAlert:[response valueForKey:@"message"]];
    }
}
//Localization stuffs
-(void)localization{
    [self.lblTitle setText:[LOCALIZATION localizedStringForKey:@"register"]];
    [self.btnSubmit setTitle:[LOCALIZATION localizedStringForKey:@"register"] forState:UIControlStateNormal];
    _txtFirstName.placeholder=[LOCALIZATION localizedStringForKey:@"firstname"];
    _txtLastName.placeholder=[LOCALIZATION localizedStringForKey:@"lastname"];
    _txtEmail.placeholder=[LOCALIZATION localizedStringForKey:@"email"];
    _txtPassword.placeholder=[LOCALIZATION localizedStringForKey:@"password"];
    _txtConfirmPassword.placeholder=[LOCALIZATION localizedStringForKey:@"confirmpassword"];
    _txtPhoneNumber.placeholder=[LOCALIZATION localizedStringForKey:@"phonenumber"];
    _txtAddress.placeholder=[LOCALIZATION localizedStringForKey:@"address"];
    _txtCity.placeholder=[LOCALIZATION localizedStringForKey:@"city"];
    _txtCountry.placeholder=[LOCALIZATION localizedStringForKey:@"country"];
    
    [self adjustAlignment];
}
-(void)adjustAlignment{
    if ([[USER_DEFAULTS valueForKey:@"localization"] isEqualToString:@"AR"]) {
        _txtFirstName.textAlignment=NSTextAlignmentRight;
        _txtLastName.textAlignment=NSTextAlignmentRight;
        _txtEmail.textAlignment=NSTextAlignmentRight;
        _txtPassword.textAlignment=NSTextAlignmentRight;
        _txtConfirmPassword.textAlignment=NSTextAlignmentRight;
        _txtAddress.textAlignment=NSTextAlignmentRight;
        _txtCity.textAlignment=NSTextAlignmentRight;
        _txtCountry.textAlignment=NSTextAlignmentRight;
        _txtPhoneNumber.textAlignment=NSTextAlignmentRight;
    }else{
        _txtFirstName.textAlignment=NSTextAlignmentLeft;
        _txtLastName.textAlignment=NSTextAlignmentLeft;
        _txtEmail.textAlignment=NSTextAlignmentLeft;
        _txtPassword.textAlignment=NSTextAlignmentLeft;
        _txtConfirmPassword.textAlignment=NSTextAlignmentLeft;
        _txtAddress.textAlignment=NSTextAlignmentLeft;
        _txtCity.textAlignment=NSTextAlignmentLeft;
        _txtCountry.textAlignment=NSTextAlignmentLeft;
        _txtPhoneNumber.textAlignment=NSTextAlignmentLeft;
    }
}
@end
