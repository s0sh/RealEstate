//
//  ContactUsViewController.m
//  RealEstate
//
//  Created by macmini7 on 07/06/14.
//  Copyright (c) 2014 macmini7. All rights reserved.
//

#import "ContactUsViewController.h"
#import "UIAlertHelper.h"
#import "MFSideMenu.h"

@interface ContactUsViewController ()

@end

@implementation ContactUsViewController{
     NSMutableArray * keyboardfieldsArray;
    NSMutableArray *categoriesArray;
    NSMutableArray *ids;
    UIPickerView *pickerView;
    int index;
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
    [self getCategories];
    index=0;
    categoriesArray=[[NSMutableArray alloc]init];
    CGRect pickerFrame = CGRectMake(0, 40, 0, 0);
    pickerView = [[UIPickerView alloc] initWithFrame:pickerFrame];
    pickerView.showsSelectionIndicator = YES;
    pickerView.dataSource = self;
    pickerView.delegate = self;
    _txtCategory.inputView=pickerView;
    //Call bskeyboard settings
    [self bsKeyboardSetting];
    _txtViewMsg.text=[LOCALIZATION localizedStringForKey:@"message"];
    ids=[[NSMutableArray alloc]init];
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
//BS keyboard settings
-(void)bsKeyboardSetting{
    
    keyboardfieldsArray = [NSMutableArray arrayWithObjects:
                           _txtEmail,_txtCategory,
                           _txtViewMsg,nil];
   	
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
    if (textField==_txtCategory) {
        _txtCategory.text=[categoriesArray objectAtIndex:[pickerView selectedRowInComponent:0]];
    }
    [self.keyboardControls setActiveField:textField];
}
- (void)textViewDidBeginEditing:(UITextView *)textView{
    if ([textView.text isEqualToString:[LOCALIZATION localizedStringForKey:@"message"]]) {
        textView.text=@"";
    }
    [self.keyboardControls setActiveField:textView];
}
- (void)textViewDidEndEditing:(UITextView *)textView{
    if (textView.text.length==0) {
        textView.text=[LOCALIZATION localizedStringForKey:@"message"];
    }
    [self.keyboardControls setActiveField:textView];
}
- (IBAction)submitClicked:(id)sender {
    
    if (_txtViewMsg.isFirstResponder) {
        [_txtViewMsg resignFirstResponder];
    }else if(_txtEmail.isFirstResponder){
        [_txtViewMsg resignFirstResponder];
    }
    
    if (self.txtEmail.text.length<1 ||[DELEGATE trimWhiteSpaces:self.txtEmail.text].length<1) {
        [UIAlertHelper showAlert:[LOCALIZATION localizedStringForKey:@"enteremail"]];
        return;
    }
    if (![self validateEmail:[self.txtEmail.text stringByTrimmingCharactersInSet:
                                    [NSCharacterSet whitespaceAndNewlineCharacterSet]]]) {
        [UIAlertHelper showAlert:[LOCALIZATION localizedStringForKey:@"entervalidemail"]];
        return;
        
    }
    if(self.txtViewMsg.text.length<1 ||[DELEGATE trimWhiteSpaces:self.txtViewMsg.text].length<1 ||[_txtViewMsg.text isEqualToString:[LOCALIZATION localizedStringForKey:@"message"]]){
        [UIAlertHelper showAlert:[LOCALIZATION localizedStringForKey:@"entermsg"]];
        return;
    }
    
    [self contactUs:@"" email:[DELEGATE trimWhiteSpaces:self.txtEmail.text] message:[DELEGATE trimWhiteSpaces:self.txtViewMsg.text] cateId:[ids objectAtIndex:index]];
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
//Validate email method
- (BOOL) validateEmail: (NSString *)candidate {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:candidate];
}
//Api call
-(void)contactUs:(NSString*)userid email:(NSString*)email message:(NSString*)message cateId:(NSString *)cateId {
    [self.mc contactUs:userid email:email message:message cateId:(NSString *)cateId selector:@selector(contactUsFInished:)];
}
-(void)contactUsFInished:(NSDictionary*)response{
    
    NSLog(@"==>> %@",response);
    
    if ([[response valueForKey:@"successful"] isEqualToString:@"true"]) {
        _txtEmail.text=@"";
        _txtViewMsg.text=[LOCALIZATION localizedStringForKey:@"message"];
        _txtCategory.text=@"";
        [UIAlertHelper showAlert:[LOCALIZATION localizedStringForKey:@"msgsubmit"]];
    }else{
        [UIAlertHelper showAlert:[response valueForKey:@"message"]];
    }
}
-(void)getCategories{
    [self.mc getCategories:@selector(getCategoriesFInished:)];
}
-(void)getCategoriesFInished:(NSDictionary*)response{
    if ([[response valueForKey:@"successful"] isEqualToString:@"true"]) {
        categoriesArray=[NSMutableArray arrayWithArray:[[response valueForKey:@"Category"] valueForKey:@"name"]];
        ids=[NSMutableArray arrayWithArray:[[response valueForKey:@"Category"] valueForKey:@"id"]];
        NSLog(@"%@",response);
        
    }else{
        [UIAlertHelper showAlert:[response valueForKey:@"message"]];
    }

}
//Picker View Methods
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return categoriesArray.count;
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [NSString stringWithFormat:@"%@",[categoriesArray objectAtIndex:row]];
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    index=row;
    _txtCategory.text=[categoriesArray objectAtIndex:row];
}
//Localization stuffs
-(void)localization{
//    [self.lblTitle setText:[LOCALIZATION localizedStringForKey:@"contactus"]];
//    _txtEmail.placeholder=[LOCALIZATION localizedStringForKey:@"email"];
//    _txtCategory.placeholder=[LOCALIZATION localizedStringForKey:@"category"];
//    [self.btnSubmit setTitle:[LOCALIZATION localizedStringForKey:@"submit"] forState:UIControlStateNormal];
//    [self adjustAlignment];
}
-(void)adjustAlignment{
   
    CGRect frame;
    if ([[USER_DEFAULTS valueForKey:@"localization"] isEqualToString:@"AR"]) {
        
        _txtEmail.textAlignment=NSTextAlignmentRight;
        _txtCategory.textAlignment=NSTextAlignmentRight;
        _txtViewMsg.textAlignment=NSTextAlignmentRight;
        
        frame=_btnMenu.frame;
        frame.origin.x=frame.origin.x=240;
        _btnMenu.frame=frame;
    
    }else{
        
        _txtEmail.textAlignment=NSTextAlignmentLeft;
        _txtCategory.textAlignment=NSTextAlignmentLeft;
        _txtViewMsg.textAlignment=NSTextAlignmentLeft;
        
        frame=_btnMenu.frame;
        frame.origin.x=frame.origin.x=-20;
        _btnMenu.frame=frame;
    }
}


@end
