//
//  EmailViewController.h
//  RealEstate
//
//  Created by Roman Bigun on 04/07/14.
//  Copyright (c) 2014 Roman Bigun All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ModelClass.h"
#import "BSKeyboardControls.h"
#import "TPKeyboardAvoidingScrollView.h"


@interface EmailViewController : UIViewController<UITextFieldDelegate,UITextViewDelegate,BSKeyboardControlsDelegate,UIAlertViewDelegate>

@property (strong, nonatomic) IBOutlet UIView *viewContainer;
@property (weak, nonatomic) IBOutlet UILabel *lblTitleHeader;
@property(strong)ModelClass *mc;
@property (nonatomic, strong) BSKeyboardControls *keyboardControls;
@property (weak, nonatomic) IBOutlet TPKeyboardAvoidingScrollView *scroll;
@property (weak, nonatomic) IBOutlet UIButton *btnSendEmail;
@property (weak, nonatomic) IBOutlet UITextField *txtReceiver;
@property (weak, nonatomic) IBOutlet UITextField *txtSubject;
@property (weak, nonatomic) IBOutlet UITextView *txtMessage;
@property (weak, nonatomic) IBOutlet UITextField *txtFromUser;
@property (retain,nonatomic)NSMutableDictionary *details;
@property (weak, nonatomic) IBOutlet UILabel *lblFromCaption;
@property (weak, nonatomic) IBOutlet UILabel *lblMessageCaption;

- (IBAction)backBtnClicked:(id)sender;
- (IBAction)sendClicked:(id)sender;
@end
