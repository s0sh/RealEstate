//
//  EmailViewController.m
//  RealEstate
//
//  Created by macmini7 on 04/07/14.
//  Copyright (c) 2014 macmini7. All rights reserved.
//

#import "EmailViewController.h"
#import "UIAlertHelper.h"

@interface EmailViewController ()

@end

@implementation EmailViewController{
    NSMutableArray * keyboardfieldsArray;
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
    [self initAndSerFonts];
}
-(void)viewWillAppear:(BOOL)animated{
    [self localization];
}
-(void)initAndSerFonts{
   
    //Model class init
    self.mc=[[ModelClass alloc]init];
    self.mc.delegate=self;
    [_scroll addSubview:_viewContainer];
    [_scroll setContentSize:_viewContainer.frame.size];
    //Call bskeyboard settings
    [self bsKeyboardSetting];
    //Ad
    [DELEGATE addIntegration:self];
    
    if ([[NSUserDefaults standardUserDefaults] valueForKey:@"user"]) {
        
        _txtFromUser.text=[[[NSUserDefaults standardUserDefaults] valueForKey:@"user"] valueForKey:@"email"];
        
    }
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)backBtnClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)sendClicked:(id)sender {
    [self validatesInputs];
}
//BS keyboard settings
-(void)bsKeyboardSetting{
    keyboardfieldsArray = [NSMutableArray arrayWithObjects:
                           _txtFromUser,_txtMessage
                           ,nil];
    [self setKeyboardControls:[[BSKeyboardControls alloc] initWithFields:keyboardfieldsArray]];
    [self.keyboardControls setDelegate:self];
}
- (void)keyboardControls:(BSKeyboardControls *)keyboardControls selectedField:(UIView *)field inDirection:(BSKeyboardControlsDirection)direction{
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
- (void)textViewDidBeginEditing:(UITextView *)textView{
    
    [self.keyboardControls setActiveField:textView];
}
- (void)textViewDidEndEditing:(UITextView *)textView{
   
    [self.keyboardControls setActiveField:textView];
}

//Validating user inputs and sneding mail
-(void)validatesInputs{
    
    [self.view endEditing:YES];
    
    if (self.txtFromUser.text.length<1 ||[DELEGATE trimWhiteSpaces:self.txtFromUser.text].length<1) {
        [UIAlertHelper showAlert:[LOCALIZATION localizedStringForKey:@"enteremail"]];
        return;
    }
    if (![self validateEmail:[self.txtFromUser.text stringByTrimmingCharactersInSet:
                              [NSCharacterSet whitespaceAndNewlineCharacterSet]]]) {
        [UIAlertHelper showAlert:[LOCALIZATION localizedStringForKey:@"entervalidemail"]];
        return;
        
    }
    
    if(self.txtMessage.text.length<1 ||[DELEGATE trimWhiteSpaces:self.txtMessage.text].length<1){
        [UIAlertHelper showAlert:[LOCALIZATION localizedStringForKey:@"entermsg"]];
        return;
    }
    
    [self sendEmail:[DELEGATE trimWhiteSpaces:self.txtFromUser.text] to_email:[[_details valueForKey:@"Property"] valueForKey:@"email"] message:[DELEGATE trimWhiteSpaces:self.txtMessage.text] subject:[NSString stringWithFormat:@"Inquiry- %@",[[_details valueForKey:@"Property"] valueForKey:@"title"]]];
    

}
//Validate email method
- (BOOL)validateEmail: (NSString *)candidate {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:candidate];
}
//Api method for sending email
-(void)sendEmail:(NSString*)from_email to_email:(NSString *)to_email message:(NSString *)message subject:(NSString*)subject{
    
    [self.mc sendEmail:from_email to_email:to_email message:message subject:subject selector:@selector(sendEmailFinished:)];
}
-(void)sendEmailFinished:(NSDictionary*)response{
    
    if ([[response valueForKey:@"successful"] isEqualToString:@"true"]) {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Erminesoft" message:@"Email send successfully !" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        
    }else{
        [UIAlertHelper showAlert:[response valueForKey:@"message"]];
    }
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    [self.navigationController popViewControllerAnimated:YES];
}
//Localization stuffs
-(void)localization{
    [self.lblTitleHeader setText:[LOCALIZATION localizedStringForKey:@"email"]];
    _lblFromCaption.text=[LOCALIZATION localizedStringForKey:@"email"];
    _lblMessageCaption.text=[LOCALIZATION localizedStringForKey:@"message"];
    [_btnSendEmail setTitle:[LOCALIZATION localizedStringForKey:@"send"] forState:UIControlStateNormal];
    [self adjustAlignment];
}
-(void)adjustAlignment{
    if ([[USER_DEFAULTS valueForKey:@"localization"] isEqualToString:@"AR"]) {
        _txtFromUser.textAlignment=NSTextAlignmentRight;
        _txtMessage.textAlignment=NSTextAlignmentRight;
    }else{
        _txtFromUser.textAlignment=NSTextAlignmentLeft;
        _txtMessage.textAlignment=NSTextAlignmentLeft;
    }
}
@end
