//
//  ContactUsViewController.h
//  RealEstate
//
//  Created by Roman Bigun on 07/06/14.
//  Copyright (c) 2014 Roman Bigun All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ModelClass.h"
#import "BSKeyboardControls.h"
#import "TPKeyboardAvoidingScrollView.h"

@interface ContactUsViewController : UIViewController<UITextFieldDelegate,UITextViewDelegate,BSKeyboardControlsDelegate,UIPickerViewDataSource,UIPickerViewDelegate>

@property(strong)ModelClass *mc;
@property (weak, nonatomic) IBOutlet UITextView *txtViewMsg;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UITextField *txtEmail;
@property (nonatomic, strong) BSKeyboardControls *keyboardControls;
@property (weak, nonatomic) IBOutlet UITextField *txtCategory;
@property (weak, nonatomic) IBOutlet TPKeyboardAvoidingScrollView *viewscroll;
- (IBAction)submitClicked:(id)sender;
- (IBAction)menuClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *btnSubmit;
@property (weak, nonatomic) IBOutlet UIButton *btnMenu;
@end
