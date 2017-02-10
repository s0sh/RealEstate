//
//  RegisterViewController.h
//  RealEstate
//
//  Created by macmini7 on 05/06/14.
//  Copyright (c) 2014 macmini7. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TPKeyboardAvoidingScrollView.h"
#import "ModelClass.h"
#import "BSKeyboardControls.h"

@interface RegisterViewController : UIViewController<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIAlertViewDelegate,UITextFieldDelegate,BSKeyboardControlsDelegate>

@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (strong, nonatomic) IBOutlet UIView *viewContainer;
@property (weak, nonatomic) IBOutlet TPKeyboardAvoidingScrollView *viewscroll;
@property (weak, nonatomic) IBOutlet UIImageView *ImgProfilePic;
@property (weak, nonatomic) IBOutlet UITextField *txtFirstName;
@property (weak, nonatomic) IBOutlet UITextField *txtLastName;
@property (weak, nonatomic) IBOutlet UITextField *txtEmail;
@property (weak, nonatomic) IBOutlet UITextField *txtPassword;
@property (weak, nonatomic) IBOutlet UITextField *txtConfirmPassword;
@property (weak, nonatomic) IBOutlet UITextField *txtPhoneNumber;
@property (weak, nonatomic) IBOutlet UITextField *txtAddress;
@property (weak, nonatomic) IBOutlet UITextField *txtCity;
@property (weak, nonatomic) IBOutlet UITextField *txtState;
@property (weak, nonatomic) IBOutlet UITextField *txtCountry;

@property (weak, nonatomic) IBOutlet UIButton *btnSubmit;
@property (nonatomic, strong) BSKeyboardControls *keyboardControls;
@property(strong)ModelClass *mc;
- (IBAction)takePhotoClicked:(id)sender;
- (IBAction)submitClicked:(id)sender;
- (IBAction)backBtnClicked:(id)sender;
@end
