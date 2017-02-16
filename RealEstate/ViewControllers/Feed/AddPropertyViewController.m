//
//  AddPropertyViewController.m
//  RealEstate
//
//  Created by Peerbits on 17/06/14.
//  Copyright (c) 2014 Roman Bigun All rights reserved.
//

#import "AddPropertyViewController.h"
#import "Annotations.h"
#import "UIAlertHelper.h"
#import <MapKit/MapKit.h>
#import "LocationServices.h"
#import "SBJSON.h"
#import "UIButton+WebCache.h"
#import <Accounts/Accounts.h>
@import AddressBookUI;
#define METERS_PER_MILE 300.0

@interface AddPropertyViewController ()

@end

@implementation AddPropertyViewController{
    
    double selectedLatitude;
    double selectedLongitude;
    NSMutableDictionary *images;
    NSMutableArray *imagesIds;
    
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    images=[[NSMutableDictionary alloc]init];
    imagesIds=[[NSMutableArray alloc]init];
    [self.mapPropertyLocation setMapType:MKMapTypeHybridFlyover];
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"Countries" ofType:@"plist"];
    NSDictionary *dict = [[NSDictionary alloc] initWithContentsOfFile:filePath];
    countriesENArray = [NSArray arrayWithArray:[dict objectForKey:@"EN"]];
    countriesARArray = [NSArray arrayWithArray:[dict objectForKey:@"AR"]];
    if ([[USER_DEFAULTS valueForKey:@"localization"] isEqualToString:@"AR"])
    {
        appLngCountriesArray = [NSArray arrayWithArray:countriesARArray];
    }
    else
    {
        appLngCountriesArray = [NSArray arrayWithArray:countriesENArray];
    
    }
    propertyImageDictionary = [[NSMutableDictionary alloc]init];
    
    [self.scroll_add_property_view addSubview:self.viewContainer];
    
    [_scroll_add_property_view setContentSize:self.viewContainer.frame.size];
    
    float spanX = 5.0;
    float spanY = 5.0;
    MKCoordinateRegion region;
    region.center.latitude = 49.9935;
    region.center.longitude = 36.230383;
    region.span.latitudeDelta = spanX;
    region.span.longitudeDelta = spanY;
    self.mapPropertyLocation.region=region;
    self.mc = [[ModelClass alloc]init];
    self.mc.delegate = self;
    
    UILongPressGestureRecognizer *lpgr = [[UILongPressGestureRecognizer alloc]
                                          initWithTarget:self action:@selector(handleLongPress:)];
    lpgr.minimumPressDuration = 1.0;
    [self.mapPropertyLocation addGestureRecognizer:lpgr];
    
    [self bsKeyboardSetting];
    [DELEGATE addIntegration:self];
    _textfield_search_tag.tagDelegate= self;
    tagsArray=[[NSMutableArray alloc]init];
    [_button_deleteproperty setHidden:DELEGATE.isAddingProperty];
    [_button_back setHidden:DELEGATE.isAddingProperty];
    [_button_menu setHidden:!DELEGATE.isAddingProperty];
    sUserId = [USER_DEFAULTS valueForKeyPath:@"user.userid"];
    _textfield_property_type.inputView=self.picker_PropertyZoning;
    _textfield_zoning.inputView=self.picker_PropertyZoning;
    _textfield_country.inputView=self.picker_PropertyZoning;
    
    isPropertyPicker = NO;
    isZoningPicker = NO;
    isCountryPicker = NO;
    
    x = _view_add_otherproperty_view.frame.origin.x;
    y = _view_add_otherproperty_view.frame.origin.y;
    w = _view_add_otherproperty_view.frame.size.width;
    h = _view_add_otherproperty_view.frame.size.height;
    
    
    [_textfield_title setFont:TextFontLight(16)];
    [_textfield_price setFont:TextFontLight(16)];
    [_textfield_location setFont:TextFontLight(16)];
    [_textfield_city setFont:TextFontLight(16)];
    [_textfield_state setFont:TextFontLight(16)];
    [_textfield_country setFont:TextFontLight(16)];
    [_textfield_zipcode setFont:TextFontLight(16)];
    [_textfield_property_type setFont:TextFontLight(16)];
    [_textfield_country  setFont:TextFontLight(16)];
    [_textfield_other_property_type setFont:TextFontLight(16)];
    [_textfield_zoning setFont:TextFontLight(16)];
    [_textfield_search_tag setFont:TextFontLight(16)];
    [_textview_description setFont:TextFontLight(16)];
    [_label_currency setFont:TextFontLight(16)];
    [_lblPropertyCaption setFont:TextFontLight(18)];
    [_lblDescriptionCaption setFont:TextFontLight(18)];
    
    // Do any additional setup after loading the view from its nib.
    if (DELEGATE.isAddingProperty) {
        
        [self.label_header_addproperty setFont:TextFont(22)];
        [_label_header_addproperty setText:[LOCALIZATION localizedStringForKey:@"addproperty"]];
        [_addNEditProperty setTitle:[LOCALIZATION localizedStringForKey:@"addproperty"] forState:UIControlStateNormal];
        sPropertyId=@"0";
        
    }else{
        
        [self.label_header_addproperty setText:[LOCALIZATION localizedStringForKey:@"editproperty"]];
        [_addNEditProperty setTitle:[LOCALIZATION localizedStringForKey:@"editproperty"] forState:UIControlStateNormal];
        
        sPropertyId = [_property_detail_dictionary valueForKeyPath:@"Property.id"];
        sTitle = [_property_detail_dictionary valueForKeyPath:@"Property.title"];
        sDescription = [_property_detail_dictionary valueForKeyPath:@"Property.description"];
        sLocation = [_property_detail_dictionary valueForKeyPath:@"Property.location"];
        sCity = [_property_detail_dictionary valueForKeyPath:@"Property.city"];
        sState = [_property_detail_dictionary valueForKeyPath:@"Property.state"];
        sCountry = [_property_detail_dictionary valueForKeyPath:@"Property.country"];
        sZipcode = [_property_detail_dictionary valueForKeyPath:@"Property.zipcode"];
        sPrice = [_property_detail_dictionary valueForKeyPath:@"Property.price"];
        sPropertyType = [_property_detail_dictionary valueForKeyPath:@"Property.property_type"];
        sOtherPropertyType = [_property_detail_dictionary valueForKeyPath:@"Property.other_value"];
        sZoning = [_property_detail_dictionary valueForKeyPath:@"Property.zoning"];
        sSearchTag = [_property_detail_dictionary valueForKeyPath:@"Property.tags"];
        tagsArray=[NSMutableArray arrayWithArray:[sSearchTag componentsSeparatedByString:@","]];
        selectedLatitude=[[_property_detail_dictionary valueForKeyPath:@"Property.latitude"] doubleValue];
        selectedLongitude=[[_property_detail_dictionary valueForKeyPath:@"Property.longitude"] doubleValue];
        [self preparemap];
        
        NSMutableArray * otherimagesarray = [[NSMutableArray alloc]initWithArray:[_property_detail_dictionary valueForKeyPath:@"Property.images"]];
        [images removeAllObjects];
        
        for (int i=0; i<otherimagesarray.count; i++) {
            NSMutableDictionary *dict=[[NSMutableDictionary alloc]init];
            
            [dict setValue:[[otherimagesarray objectAtIndex:i] valueForKey:@"image_id"] forKey:@"id"];
            [dict setValue:[[otherimagesarray objectAtIndex:i] valueForKey:@"image"]forKey:@"url"];
            [images setValue:dict forKey:[NSString stringWithFormat:@"%d",i+1]];
            UIButton *holder=(UIButton*)[self.view_add_otherproperty_view viewWithTag:i+1];
            [holder sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMAGE_PATH,[[otherimagesarray objectAtIndex:i] valueForKey:@"image"]]]forState:UIControlStateNormal];
            
            
        }
        [self adjustPhoto];
        _textfield_title.text = sTitle;
        _textfield_price.text = sPrice;
        _textfield_location.text = sLocation;
        _textfield_city.text = sCity;
        _textfield_state.text = sState;
        _textfield_country.text = sCountry;
        _textfield_zipcode.text = sZipcode;
        _textfield_property_type.text = sPropertyType;
        _textfield_other_property_type.text = sOtherPropertyType;
        _textfield_zoning.text = sZoning;
        _textfield_search_tag.tags=tagsArray;
        _textview_description.text = sDescription;
        sPropertyType = [sPropertyType substringToIndex:1];
        ([sZoning isEqualToString:[LOCALIZATION  localizedStringForKey:@"retail"]])?(sZoning = @"RT"):(sZoning = [sZoning substringToIndex:1]);
    }
}
-(void)viewWillAppear:(BOOL)animated{
    
    [self localization];
}
- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



/*---------------------------------------------------------------------------------------------------------*
 >> BSKeyboard Seup
 *---------------------------------------------------------------------------------------------------------*/

-(void)bsKeyboardSetting{
    
    keyboardfieldsArray = [NSMutableArray arrayWithObjects:
                           _textfield_title,
                           _textfield_price,
                           _textfield_location,
                           _textfield_city,
                           _textfield_country,
                          _textfield_property_type,
                           _textfield_zoning,
                           _textfield_search_tag,
                           _textview_description,
                           _textfield_country,
                           nil];
   
    [self setKeyboardControls:[[BSKeyboardControls alloc] initWithFields:keyboardfieldsArray]];
    [self.keyboardControls setDelegate:self];
    
    
}
-(void)bsKeyboardSetting2{
    
    keyboardfieldsArray = [NSMutableArray arrayWithObjects:
                           _textfield_title,
                           _textfield_price,
                           _textfield_location,
                           _textfield_city,
                           _textfield_country,
                           _textfield_property_type,
                           _textfield_other_property_type,
                           _textfield_zoning,
                           _textfield_search_tag,
                           _textview_description,
                           _textfield_country,
                           nil];
    
    [self setKeyboardControls:[[BSKeyboardControls alloc] initWithFields:keyboardfieldsArray]];
    [self.keyboardControls setDelegate:self];
    
    
}

- (void)keyboardControls:(BSKeyboardControls *)keyboardControls selectedField:(UIView *)field inDirection:(BSKeyboardControlsDirection)direction {
    
}


- (void)keyboardControlsDonePressed:(BSKeyboardControls *)keyboardControls{
    [self.view endEditing:YES];
}

/*---------------------------------------------------------------------------------------------------------*
 >> Textfield & Textview delegate methods
 *---------------------------------------------------------------------------------------------------------*/


- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    //[self.keyboardControls setActiveField:textField];
    
    if (textField == _textfield_other_property_type){
        [_textfield_zoning becomeFirstResponder];
        return NO;
    }
    else{
        [textField resignFirstResponder];
        return YES;
    }
    
}

//CHECKPOINT
-(void)textFieldDidBeginEditing:(UITextField *)textField {
    
    if (textField == _textfield_country) {
        
        isPropertyPicker = NO; isZoningPicker = NO; isCountryPicker = YES;
        sPropertyType = @"C";
        return;
    }
    
    if (textField == _textfield_property_type) {
        pickerArray = [[NSMutableArray alloc]initWithArray:propertytypeArray];
        [_picker_PropertyZoning reloadAllComponents];
        [_picker_PropertyZoning selectRow:0 inComponent:0 animated:NO];
        [_textfield_property_type setInputView:_picker_PropertyZoning];
        isPropertyPicker = YES; isZoningPicker = NO;
        sPropertyType = @"S";
         _textfield_property_type.text = [propertytypeArray objectAtIndex:0];
    }
    if (textField == _textfield_zoning) {
        pickerArray = [[NSMutableArray alloc]initWithArray:zoningArray];
        [_picker_PropertyZoning reloadAllComponents];
        [_picker_PropertyZoning selectRow:0 inComponent:0 animated:NO];
        [_textfield_zoning setInputView:_picker_PropertyZoning];
        isPropertyPicker = NO; isZoningPicker = YES;
         sZoning = @"R";
        _textfield_zoning.text = [zoningArray objectAtIndex:0];
    }
  
    [self.keyboardControls setActiveField:textField];
    
}


-(void)textFieldDidEndEditing:(UITextField *)textField {
    [self.keyboardControls setActiveField:textField];
    
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    
    return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView{
     [self.keyboardControls setActiveField:textView];
}
- (void)textViewDidEndEditing:(UITextView *)textView{
    [self.keyboardControls setActiveField:textView];
}
/*---------------------------------------------------------------------------------------------------------*
 >> Button Action methods
 *---------------------------------------------------------------------------------------------------------*/

- (IBAction)menuClicked:(id)sender {
    
    if ([[USER_DEFAULTS valueForKey:@"localization"] isEqualToString:@"AR"]) {
        [self.menuContainerViewController toggleRightSideMenuCompletion:^{
            
        }];
    }else{
        [self.menuContainerViewController toggleLeftSideMenuCompletion:^{
            
        }];
    }
}

- (IBAction)showMapClicked:(id)sender {
    [self.view endEditing:YES];
    [self.view addSubview:self.viewMap];
}
- (IBAction)btnApplyClicked:(id)sender {
    
    if (self.mapPropertyLocation.annotations.count==0 ) {
        
        [UIAlertHelper showAlert:@"No location selected"];
        return;
    }
   
    [self getpalce:selectedLatitude longitude:selectedLongitude];
}

- (IBAction)currentLocationClicked:(id)sender {
    
    if([CLLocationManager authorizationStatus]==kCLAuthorizationStatusDenied){
        UIAlertView    *alert = [[UIAlertView alloc] initWithTitle:@"App Permission Denied"
                                                           message:@"To re-enable, please go to Settings and turn on Location Service for this app."
                                                          delegate:nil
                                                 cancelButtonTitle:@"OK"
                                                 otherButtonTitles:nil];
        [alert show];
        return;
    }
    selectedLatitude=gLocationServices.latitude;
    selectedLongitude=gLocationServices.longitude;
    [self preparemap];
    
}

- (IBAction)propetyPhoto:(UIButton *)sender {
    
    uploadphoto_buttonindex = sender.tag;
    [[[UIActionSheet alloc]initWithTitle:@"" delegate:self cancelButtonTitle:[LOCALIZATION localizedStringForKey:@"cancel"] destructiveButtonTitle:nil otherButtonTitles:[LOCALIZATION localizedStringForKey:@"camera"],[LOCALIZATION localizedStringForKey:@"library"], [LOCALIZATION localizedStringForKey:@"removeimg"]
      ,nil] showInView:_scroll_add_property_view];
    
}
- (IBAction)addNEditProperty:(id)sender {
    
    if ([self isValidPropertyEntry]) {
        sSearchTag = [tagsArray componentsJoinedByString:@","];
        self.mc = [[ModelClass alloc]init];
        self.mc.delegate = self;
        [self populateImagesId];
        [self.mc addProperty:sPropertyId UserId:sUserId Title:sTitle Price:sPrice Location:sLocation City:sCity State:sState Country:sCountry Zipcode:sZipcode PropertyType:sPropertyType Other_Property_Type:sOtherPropertyType Zoning:sZoning Tags:sSearchTag Description:sDescription Images:imagesIds latitude:selectedLatitude longitude:selectedLongitude  selector:@selector(addPropertyConfirmation:)];
    }else{
        
        [[[UIAlertView alloc]initWithTitle:alerttitle message:alertmessage delegate:nil cancelButtonTitle:[LOCALIZATION localizedStringForKey:@"ok"] otherButtonTitles:nil, nil] show];
    }
}

- (IBAction)backNavigation:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)openPickerView:(UIButton *)sender {
    
    switch (sender.tag) {
        case 1: [_textfield_property_type becomeFirstResponder]; break;
        case 2: [_textfield_zoning becomeFirstResponder]; break;
        default:
            break;
    }
}
- (IBAction)deleteProperty:(id)sender {
    sUserId = [USER_DEFAULTS valueForKeyPath:@"user.userid"];
    _alert_delete_property = [[UIAlertView alloc]initWithTitle:[LOCALIZATION localizedStringForKey:@"deleteproperty"] message:[LOCALIZATION localizedStringForKey:@"deletesure"] delegate:self cancelButtonTitle:[LOCALIZATION localizedStringForKey:@"yes"] otherButtonTitles:[LOCALIZATION localizedStringForKey:@"no"], nil];
    [_alert_delete_property show];
    
}
-(void)deletePropertyStatus:(NSMutableDictionary *)response{
    
    [[[UIAlertView alloc]initWithTitle:@"" message:[response objectForKey:@"message"] delegate:self cancelButtonTitle:[LOCALIZATION localizedStringForKey:@"ok"] otherButtonTitles:nil] show];
    if ([[response objectForKey:@"successful"] isEqualToString:@"true"]) {
        DELEGATE.isComingFromMyListing = YES;
        FeedViewController * fvc = [[FeedViewController alloc]initWithNibName:NSStringFromClass([FeedViewController class]) bundle:nil];
        [self.navigationController pushViewController:fvc animated:YES];
    }else{
        
    }
}

/*---------------------------------------------------------------------------------------------------------*
 >> PickerView Delegate methods for CardIssuer TextField
 *---------------------------------------------------------------------------------------------------------*/
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return [pickerArray count];
}
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    NSString *title =[pickerArray objectAtIndex:row];
    return title;
}
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return 50.0;
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    
   // [numberPick selectRow:
    if (isPropertyPicker) {
        _textfield_property_type.text = [propertytypeArray objectAtIndex:row];
        if ([_textfield_property_type.text isEqualToString:[LOCALIZATION localizedStringForKey:@"other"]]) {
            [UIView animateWithDuration:0.3 animations:^{
                [_view_add_otherproperty_view setFrame:CGRectMake(x,y + 50,w,h)];
                CGRect frame=_viewContainer.frame;
                frame.size.height=_view_add_otherproperty_view.frame.origin.y+_view_add_otherproperty_view.frame.size.height;
                _viewContainer.frame=frame;
                [self.scroll_add_property_view setContentSize:self.viewContainer.frame.size];
            }];
        }else{
            [_view_add_otherproperty_view setFrame:CGRectMake(x,y,w,h)];
        }
        switch (row) {
            case 0: sPropertyType = @"S"; break;
            case 1: sPropertyType = @"R"; break;
            case 2: sPropertyType = @"I"; break;
            case 3: sPropertyType = @"O"; break;
            default: sPropertyType = @"S"; break;
        }
    }
    if (isZoningPicker) {
        _textfield_zoning.text = [zoningArray objectAtIndex:row];
        switch (row) {
            case 0: sZoning = @"R"; break;
            case 1: sZoning = @"RT"; break;
            case 2: sZoning = @"C"; break;
            case 3: sZoning = @"M"; break;
            default: sZoning = @"R"; break;
        }
    }
    if (isCountryPicker) {
        _textfield_country.text = [appLngCountriesArray objectAtIndex:row];
        switch (row) {
            case 0: sZoning = @"R"; break;
            case 1: sZoning = @"RT"; break;
            case 2: sZoning = @"C"; break;
            case 3: sZoning = @"M"; break;
            default: sZoning = @"R"; break;
        }
    }
    
}

/***************************************************************************************************
 - Action sheet delegate methods
 **************************************************************************************************/


- (void)actionSheet:(UIActionSheet *)action clickedButtonAtIndex:(NSInteger)buttonIndex {
    //int i = buttonIndex;
    UIImagePickerController *imagepicker = [[UIImagePickerController alloc] init];
    
    switch(buttonIndex)
    {
        case 0 : {
            if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
                [[[UIAlertView alloc] initWithTitle:@"Property Picture" message:@"This device has no camera" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
                return;
            } else {
                imagepicker.sourceType = UIImagePickerControllerSourceTypeCamera;
                imagepicker.delegate = self;
                [self presentViewController:imagepicker animated:YES completion:nil];
            }
        }
            break;
            
        case 1 : {
            imagepicker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
            imagepicker.delegate = self;
            [self presentViewController:imagepicker animated:YES completion:nil];
        }
            break;
            
        case 2 : {

            UIButton *holder=(UIButton*)[self.view_add_otherproperty_view viewWithTag:uploadphoto_buttonindex];
            [holder setImage:nil forState:UIControlStateNormal];
            [images removeObjectForKey:[NSString stringWithFormat:@"%d",uploadphoto_buttonindex]];
            
            
            }
        default:
            break;
    }
    
}

-(void)adjustPhoto{
    
    if ([[images allKeys] count]>=3) {
        [self.view_add_otherproperty_view addSubview:self.photoStep2];
        [self.photoStep2 setFrame:CGRectMake(_photoStep2.frame.origin.x,347, _photoStep2.frame.size.width,  _photoStep2.frame.size.height)];
        
        CGRect frame=self.addNEditProperty.frame;
        frame.origin.y=self.photoStep2.frame.origin.y+self.photoStep2.frame.size.height+15;
        _addNEditProperty.frame=frame;
        
        frame=_view_add_otherproperty_view.frame;
        frame.size.height=_addNEditProperty.frame.origin.y+_addNEditProperty.frame.size.height+15;
        _view_add_otherproperty_view.frame=frame;
        
        frame=_viewContainer.frame;
        frame.size.height=_view_add_otherproperty_view.frame.origin.y+_view_add_otherproperty_view.frame.size.height;
        _viewContainer.frame=frame;
        
        [self.scroll_add_property_view setContentSize:self.viewContainer.frame.size];
        
        CGPoint bottomOffset = CGPointMake(0, self.scroll_add_property_view.contentSize.height - self.scroll_add_property_view.bounds.size.height);
        [self.scroll_add_property_view setContentOffset:bottomOffset animated:YES];
        
    }
    if ([[images allKeys] count]>=6) {
        
        [self.view_add_otherproperty_view addSubview:self.photoStep3];
        [self.photoStep3 setFrame:CGRectMake(_photoStep3.frame.origin.x,self.photoStep2.frame.origin.y+self.photoStep2.frame.size.height+15, _photoStep3.frame.size.width,  _photoStep3.frame.size.height)];
        
        CGRect frame=self.addNEditProperty.frame;
        frame.origin.y=self.photoStep3.frame.origin.y+self.photoStep3.frame.size.height+15;
        _addNEditProperty.frame=frame;
        
        frame=_view_add_otherproperty_view.frame;
        frame.size.height=_addNEditProperty.frame.origin.y+_addNEditProperty.frame.size.height+15;
        _view_add_otherproperty_view.frame=frame;
        
        frame=_viewContainer.frame;
        frame.size.height=_view_add_otherproperty_view.frame.origin.y+_view_add_otherproperty_view.frame.size.height;
        _viewContainer.frame=frame;
        
        [self.scroll_add_property_view setContentSize:self.viewContainer.frame.size];
        CGPoint bottomOffset = CGPointMake(0, self.scroll_add_property_view.contentSize.height - self.scroll_add_property_view.bounds.size.height);
        [self.scroll_add_property_view setContentOffset:bottomOffset animated:YES];
        
    }
}


/***************************************************************************************************
 - UIImagePickerController delegate methods
 **************************************************************************************************/

- (void)imagePickerController:(UIImagePickerController *)imagepicker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    

    NSData* content = UIImageJPEGRepresentation(info[UIImagePickerControllerOriginalImage],0.5);
    
     UIImage *chosenImage = [UIImage imageWithData:content];
     UIButton *holder=(UIButton*)[self.view_add_otherproperty_view viewWithTag:uploadphoto_buttonindex];
     [holder setImage:chosenImage forState:UIControlStateNormal];
    
    if (DELEGATE.isAddingProperty){
        [self addImage:@"" propertyid:@"" userid:[NSString stringWithFormat:@"%@",[USER_DEFAULTS valueForKeyPath:@"user.userid"]] image:chosenImage];
    }else{
        
        if ([[images allKeys] containsObject:[NSString stringWithFormat:@"%d",uploadphoto_buttonindex]]) {
            
            [self addImage:[[images valueForKey:[NSString stringWithFormat:@"%d",uploadphoto_buttonindex]] valueForKey:@"id"] propertyid:sPropertyId userid:[NSString stringWithFormat:@"%@",[USER_DEFAULTS valueForKeyPath:@"user.userid"]] image:chosenImage];
            
        }else{
            
            [self addImage:@"" propertyid:@"" userid:[NSString stringWithFormat:@"%@",[USER_DEFAULTS valueForKeyPath:@"user.userid"]] image:chosenImage];
        }
    }
    [imagepicker dismissViewControllerAnimated:YES completion:nil];
}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)imagepicker{
    [imagepicker dismissViewControllerAnimated:YES completion:nil];
    
}

/*---------------------------------------------------------------------------------------------------------*
 >> Custom local methods
 *---------------------------------------------------------------------------------------------------------*/
-(void)addPropertyConfirmation:(NSDictionary *)response{
 
     if (DELEGATE.isAddingProperty) {
         alerttitle = [LOCALIZATION localizedStringForKey:@"addproperty"];
     }else{
     alerttitle = [LOCALIZATION localizedStringForKey:@"editproperty"];
     }
     alertmessage = [response objectForKey:@"message"];
 
     if ([[response objectForKey:@"successful"] isEqualToString:@"true"]) {
         DELEGATE.isComingFromMyListing = YES;
         FeedViewController * fvc = [[FeedViewController alloc]initWithNibName:NSStringFromClass([FeedViewController class]) bundle:nil];
         [self.navigationController pushViewController:fvc animated:YES];

     } else {
 
     }
     [[[UIAlertView alloc]initWithTitle:alerttitle message:alertmessage delegate:nil cancelButtonTitle:[LOCALIZATION localizedStringForKey:@"ok"] otherButtonTitles:nil, nil]show];
 }
 
-(BOOL)isValidPropertyEntry{

    sTitle = [self.textfield_title.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    sPrice = [self.textfield_price.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    sLocation = [self.textfield_location.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    sCity = [self.textfield_city.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    sCountry = [self.textfield_country.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    sOtherPropertyType = [self.textfield_other_property_type.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    sDescription = [self.textview_description.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    alerttitle = @"Incomplete Entry";
    
    if (sTitle.length <= 0 || sPrice <= 0 || sLocation <= 0 || sCity <= 0 ||  sCountry <= 0 ||  sPropertyType <= 0 || sZoning <= 0 || sDescription <= 0) {
        if (sTitle.length <= 0) {
           // [_textfield_title becomeFirstResponder];
            alertmessage = [LOCALIZATION localizedStringForKey:@"entertitel"];
        }else if (sPrice.length <= 0) {
           // [_textfield_price becomeFirstResponder];
            alertmessage = [LOCALIZATION localizedStringForKey:@"enterprice"];
        }else if (sLocation.length <= 0) {
           // [_textfield_location becomeFirstResponder];
            alertmessage = [LOCALIZATION localizedStringForKey:@"enterlocation"];
        }else if (sCity.length <= 0) {
           // [_textfield_city becomeFirstResponder];
            alertmessage = [LOCALIZATION localizedStringForKey:@"entercity"];
        }else if (sCountry.length <= 0) {
            //[_textfield_country becomeFirstResponder];
            alertmessage = [LOCALIZATION localizedStringForKey:@"entercountry"];
        }else if (sPropertyType.length <= 0) {
            //[_textfield_property_type becomeFirstResponder];
            alertmessage = [LOCALIZATION localizedStringForKey:@"selectpropertytype"];
        }else if (sZoning.length <= 0) {
           // [_textfield_zoning becomeFirstResponder];
            alertmessage = [LOCALIZATION localizedStringForKey:@"selectzoning"];
        }else if (sDescription.length <= 0) {
           // [_textview_description becomeFirstResponder];
            alertmessage = [LOCALIZATION localizedStringForKey:@"enterdescription"];
        }
    }else if ([sPropertyType isEqualToString:[LOCALIZATION localizedStringForKey:@"other"]] && sOtherPropertyType.length <= 0) {
        alertmessage = [LOCALIZATION localizedStringForKey:@"specifyother"];
    }else if (images.allKeys.count==0) {
        alertmessage = [LOCALIZATION localizedStringForKey:@"addpropertypic"];
    }else{
        DELEGATE.drk = [[DarckWaitView alloc] initWithDelegate:nil andInterval:0.1 andMathod:nil];
        [DELEGATE.drk showWithMessage:nil];

        NSArray *temp=[NSArray arrayWithArray:[images allKeys]];
        propertyImagesArray = [[NSMutableArray alloc]init];
        
        for (int i=0; i<temp.count; i++) {
            [propertyImagesArray addObject:[images valueForKey:[temp objectAtIndex:i]]];
        }
           return YES;
    }
    
    
    return NO;
}


#pragma mark - SMTagField delegate
-(void)tagField:(SMTagField *)_tagField tagAdded:(NSString *)tag{
    [tagsArray addObject:tag];
}
-(void)tagField:(SMTagField *)_tagField tagRemoved:(NSString *)tag{
    [tagsArray removeObject:tag];
}

-(BOOL)tagField:(SMTagField *)_tagField shouldAddTag:(NSString *)tag{
    // Limits to a maximum of 5 tags and doesn't allow to add a tag called "cat"
    if(_tagField.tags.count >= 5){
        [[[UIAlertView alloc]initWithTitle:[LOCALIZATION localizedStringForKey:@"tags"] message:[LOCALIZATION localizedStringForKey:@"tagmsg"] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil]show] ;
        return NO;
    }
    return YES;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
       
    if (alertView == _alert_delete_property) {
        if (buttonIndex == 0) {
            [self.mc deleteProperty:sPropertyId UserId:sUserId selector:@selector(deletePropertyStatus:)];
        }
    }
}
-(NSString*)streetName
{

    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    CLLocation *curLocation = [[CLLocation alloc] initWithLatitude:selectedLatitude longitude:selectedLongitude];
    [geocoder reverseGeocodeLocation:curLocation completionHandler:^(NSArray *placemarks, NSError *error)
     {
         // NSLog(@"Found placemarks: %@, error: %@", placemarks, error);
         
         if (error == nil && [placemarks count] > 0)
         {
             placemark = [placemarks lastObject];
             
             
             whereAmI = ABCreateStringWithAddressDictionary(placemark.addressDictionary, YES);
             NSArray *seperated = [whereAmI componentsSeparatedByString:@"\n"];
             NSMutableString *line = [NSMutableString new];
             for (NSString *name in seperated) {
                 
                 [line appendString:[NSString stringWithFormat:@"%@, ",name]];
                 
             }
             line = [line substringToIndex:line.length-2];
             
             NSLog(@"Location 1 %@ ",line);
             
             
         }
         
     }];
    
    return whereAmI;
    
    
}

//map
-(void)preparemap{
    
    //Remove annotation placed before
    [self removeAnnotaions];
    //Add annotations;
   
    CLLocationCoordinate2D proPlace;
    proPlace.latitude = selectedLatitude;
    proPlace.longitude = selectedLongitude;
    
    Annotations *annotaion1=[Annotations alloc];
    annotaion1.coordinate= proPlace;
    annotaion1.title=@"";
    annotaion1.place_id=@"";
    
    [self.mapPropertyLocation addAnnotation:annotaion1];
    
    [self zoomToLocation];
}
//Remove previously added annotation
-(void)removeAnnotaions{
    NSInteger toRemoveCount = self.mapPropertyLocation.annotations.count;
    NSMutableArray *toRemove = [NSMutableArray arrayWithCapacity:toRemoveCount];
    for (id annotation in self.mapPropertyLocation.annotations)
        if (annotation != self.mapPropertyLocation.userLocation)
            [toRemove addObject:annotation];
    [self.mapPropertyLocation removeAnnotations:toRemove];
}
//Annotation Image change
- (MKAnnotationView *)mapView:(MKMapView *)map viewForAnnotation:(id <MKAnnotation>)annotation
{
    static NSString *annotationViewReuseIdentifier = @"annotationViewReuseIdentifier";
    MKAnnotationView *annotationView = (MKAnnotationView *)[self.mapPropertyLocation dequeueReusableAnnotationViewWithIdentifier:annotationViewReuseIdentifier];
    if (annotationView == nil)
    {
        annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:annotationViewReuseIdentifier];
    }
    annotationView.image = [UIImage imageNamed:@"location_icon"];
    annotationView.annotation = annotation;
    annotationView.canShowCallout = NO;
    annotationView.draggable=YES;
    UIButton *detailButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    annotationView.rightCalloutAccessoryView = detailButton;
    
    return annotationView;
}
//Zoom to fit annotations
- (void)zoomToLocation{
    CLLocationCoordinate2D zoomLocation;
    zoomLocation.latitude = selectedLatitude;
    zoomLocation.longitude= selectedLongitude;
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(zoomLocation, 7.5*METERS_PER_MILE,7.5*METERS_PER_MILE);
    [self.mapPropertyLocation setRegion:viewRegion animated:YES];
    [self.mapPropertyLocation regionThatFits:viewRegion];
}

- (void)mapView:(MKMapView *)mapView
 annotationView:(MKAnnotationView *)annotationView
didChangeDragState:(MKAnnotationViewDragState)newState
   fromOldState:(MKAnnotationViewDragState)oldState
{
    if (newState == MKAnnotationViewDragStateStarting)
    {
        annotationView.dragState = MKAnnotationViewDragStateDragging;
    }
    else if (newState == MKAnnotationViewDragStateEnding || newState == MKAnnotationViewDragStateCanceling)
    {
        annotationView.dragState = MKAnnotationViewDragStateNone;
    }
    if (newState == MKAnnotationViewDragStateEnding)
    {
        CLLocationCoordinate2D droppedAt = annotationView.annotation.coordinate;
        selectedLatitude=droppedAt.latitude;
        selectedLongitude=droppedAt.longitude;
    }
}
- (void)handleLongPress:(UIGestureRecognizer *)gestureRecognizer
{
    if (gestureRecognizer.state != UIGestureRecognizerStateBegan)
        return;
    CGPoint touchPoint = [gestureRecognizer locationInView:self.mapPropertyLocation];
    CLLocationCoordinate2D touchMapCoordinate =
    [self.mapPropertyLocation convertPoint:touchPoint toCoordinateFromView:self.mapPropertyLocation];
    selectedLatitude=touchMapCoordinate.latitude;
    selectedLongitude=touchMapCoordinate.longitude;
    [self preparemap];
}
-(void)getpalce:(CGFloat)latitude longitude:(CGFloat)longitude{
    //,
    CLGeocoder *ceo = [[CLGeocoder alloc]init];
    CLLocation *loc = [[CLLocation alloc]initWithLatitude:latitude longitude:longitude];
    
    [ceo reverseGeocodeLocation: loc completionHandler:
     ^(NSArray *placemarks, NSError *error) {
         if (placemarks.count==0) {
             [UIAlertHelper showAlert:[LOCALIZATION localizedStringForKey:@"notlocate"]];
             return;
         }
         
         placemark = [placemarks objectAtIndex:0];
         //String to hold address
         NSString *locatedAt = [[placemark.addressDictionary valueForKey:@"FormattedAddressLines"] componentsJoinedByString:@", "];
         locatedAt=@"";
         if ([placemark.addressDictionary valueForKey:@"Name"]) {
             locatedAt=[placemark.addressDictionary valueForKey:@"Name"];
             _textfield_location.text=[placemark.addressDictionary valueForKey:@"Name"];
         }else if([placemark.addressDictionary valueForKey:@"Street"]){
             locatedAt=[placemark.addressDictionary valueForKey:@"Street"];
             _textfield_location.text=[placemark.addressDictionary valueForKey:@"Street"];
         }
         if ([placemark.addressDictionary valueForKey:@"State"]) {
             locatedAt=[NSString stringWithFormat:@"%@ - %@",locatedAt,[placemark.addressDictionary valueForKey:@"State"]];
         }
         if ([placemark.addressDictionary valueForKey:@"Country"]) {
             locatedAt=[NSString stringWithFormat:@"%@ - %@",locatedAt,[placemark.addressDictionary valueForKey:@"Country"]];
         }
         if ([placemark.addressDictionary valueForKey:@"State"]) {
             _textfield_city.text=[placemark.addressDictionary valueForKey:@"State"];
         }
         if ([placemark.addressDictionary valueForKey:@"Country"]) {
             _textfield_country.text=[placemark.addressDictionary valueForKey:@"Country"];
         }
         [_viewMap removeFromSuperview];
     }];
}
-(void)getpalceFinished:(NSDictionary*)response{
    
    //formatted_address
    if (response.count>0) {
        _textfield_location.text=[response valueForKey:@"formatted_address"];
        if ([[response valueForKey:@"address"] valueForKey:@"locality"]) {
            _textfield_city.text=[[response valueForKey:@"address"] valueForKey:@"locality"];
        }
        if ([[response valueForKey:@"address"] valueForKey:@"country"]) {
            _textfield_country.text=[[response valueForKey:@"address"] valueForKey:@"country"];
        }
    }else{
        [UIAlertHelper showAlert:@"Could not get address !"];
    }
    [_viewMap removeFromSuperview];
}
- (IBAction)cancelClicked:(id)sender {
    [self.viewMap removeFromSuperview];
}

- (IBAction)proTypeEndEditing:(UITextField *)sender {
//    self.textfield_property_type.text= [propertytypeArray objectAtIndex:[self.picker_PropertyZoning selectedRowInComponent:0]];
//    sPropertyType = @"S";
}

- (IBAction)proZoningEndEdting:(id)sender {
//    self.textfield_zoning.text= [zoningArray objectAtIndex:[self.picker_PropertyZoning selectedRowInComponent:0]];
//    sZoning = @"R";
}
-(void)addImage:(NSString*)imageid propertyid:(NSString*)propertyid userid:(NSString*)userid image:(UIImage*)image_new {
    [self.mc addImage:imageid propertyid:propertyid userid:userid image:image_new selector:@selector(addImageFinished:)];
}
-(void)addImageFinished:(NSDictionary*)response{
        if ([[response valueForKey:@"successful"] isEqualToString:@"true"]) {
            NSMutableDictionary *dict=[[NSMutableDictionary alloc]init];
            [dict setValue:[response valueForKey:@"imageid"]forKey:@"id"];
            [dict setValue:[response valueForKey:@"url"]forKey:@"url"];
            [images setValue:dict forKey:[NSString stringWithFormat:@"%d",uploadphoto_buttonindex]];
            [self adjustPhoto];
    }else{
        [UIAlertHelper showAlert:[response valueForKey:@"message"]];
    }
}
-(void)populateImagesId{
    NSArray *temp=[NSArray arrayWithArray:[images allKeys]];
    for (int i=0; i<temp.count; i++) {
        [imagesIds addObject:[images valueForKey:[temp objectAtIndex:i]]];
    }
}

//Localization stuffs
-(void)localization{
    if (DELEGATE.isAddingProperty) {
        
        
        [_label_header_addproperty setText:[LOCALIZATION localizedStringForKey:@"addproperty"]];
        [_addNEditProperty setTitle:[LOCALIZATION localizedStringForKey:@"addproperty"] forState:UIControlStateNormal];
       
        
    }else{
        
        [self.label_header_addproperty setText:[LOCALIZATION localizedStringForKey:@"editproperty"]];
        [_addNEditProperty setTitle:[LOCALIZATION localizedStringForKey:@"editproperty"] forState:UIControlStateNormal];
    }
    [self.btnCurrentlocation setTitle:[LOCALIZATION localizedStringForKey:@"usecureentlocation"] forState:UIControlStateNormal];
    [self.btnApply setTitle:[LOCALIZATION localizedStringForKey:@"apply"] forState:UIControlStateNormal];
    
    propertytypeArray = [[NSMutableArray alloc]initWithObjects:[LOCALIZATION localizedStringForKey:@"sell"],[LOCALIZATION localizedStringForKey:@"rent"],[LOCALIZATION localizedStringForKey:@"investment"],[LOCALIZATION localizedStringForKey:@"other"], nil];
    zoningArray = [[NSMutableArray alloc]initWithObjects:[LOCALIZATION localizedStringForKey:@"residential"],[LOCALIZATION localizedStringForKey:@"retail"],[LOCALIZATION localizedStringForKey:@"commercial"],[LOCALIZATION localizedStringForKey:@"mixed"], nil];
    
    
    _textfield_title.placeholder=[LOCALIZATION localizedStringForKey:@"title"];
    _textfield_price.placeholder=[LOCALIZATION localizedStringForKey:@"price"];
    _textfield_city.placeholder=[LOCALIZATION localizedStringForKey:@"city"];
    _textfield_country.placeholder=[LOCALIZATION localizedStringForKey:@"country"];
    _textfield_property_type.placeholder=[LOCALIZATION localizedStringForKey:@"selectpropertytype"];
    _textfield_search_tag.placeholder=[LOCALIZATION localizedStringForKey:@"tags"];
    _textfield_zoning.placeholder=[LOCALIZATION localizedStringForKey:@"selectzoning"];
    _lblDescriptionCaption.text=[LOCALIZATION localizedStringForKey:@"description"];
    _lblPropertyCaption.text=[LOCALIZATION localizedStringForKey:@"propertyphoto"];
    _lblNoteLongPress.text=[LOCALIZATION localizedStringForKey:@"longpress"];
    _textfield_location.placeholder=[LOCALIZATION localizedStringForKey:@"location"];
    _textfield_other_property_type.placeholder=[LOCALIZATION localizedStringForKey:@"other"];
    //[self adjustAlignment];
}
-(void)adjustAlignment{
    
    CGRect frame;
    if ([[USER_DEFAULTS valueForKey:@"localization"] isEqualToString:@"AR"]) {
       
        _textfield_title.textAlignment=NSTextAlignmentRight;
        _textfield_price.textAlignment=NSTextAlignmentRight;
        _textfield_city.textAlignment=NSTextAlignmentRight;
        _textfield_country.textAlignment=NSTextAlignmentRight;
        _textfield_search_tag.textAlignment=NSTextAlignmentRight;
        _textview_description.textAlignment=NSTextAlignmentRight;
        _lblDescriptionCaption.textAlignment=NSTextAlignmentRight;
        _lblPropertyCaption.textAlignment=NSTextAlignmentRight;
        _textfield_property_type.textAlignment=NSTextAlignmentRight;
        _textfield_zoning.textAlignment=NSTextAlignmentRight;
        _textfield_location.textAlignment=NSTextAlignmentRight;
        _textfield_other_property_type.textAlignment=NSTextAlignmentRight;
        
        frame=_imgDownOne.frame;
        frame.origin.x=31;
        _imgDownOne.frame=frame;
        
        frame=_imgDownCountry.frame;
        frame.origin.x=31;
        _imgDownCountry.frame=frame;
        
        frame=_imgViewDownTWo.frame;
        frame.origin.x=31;
        _imgViewDownTWo.frame=frame;
        
        frame=_mapHolderView.frame;
        frame.origin.x=21;
        _mapHolderView.frame=frame;
        
        frame=_locationBox.frame;
        frame.origin.x=109;
        _locationBox.frame=frame;
        
        frame=_textfield_location.frame;
        frame.origin.x=116;
        _textfield_location.frame=frame;
        
        frame=_button_menu.frame;
        frame.origin.x=240;
        _button_menu.frame=frame;
        
        
    }else{
        
        _textfield_title.textAlignment=NSTextAlignmentLeft;
        _textfield_price.textAlignment=NSTextAlignmentLeft;
        _textfield_city.textAlignment=NSTextAlignmentLeft;
        _textfield_country.textAlignment=NSTextAlignmentLeft;
        _textfield_search_tag.textAlignment=NSTextAlignmentLeft;
        _textview_description.textAlignment=NSTextAlignmentLeft;
        _lblDescriptionCaption.textAlignment=NSTextAlignmentLeft;
        _lblPropertyCaption.textAlignment=NSTextAlignmentLeft;
        _textfield_property_type.textAlignment=NSTextAlignmentLeft;
        _textfield_zoning.textAlignment=NSTextAlignmentLeft;
        _textfield_location.textAlignment=NSTextAlignmentLeft;
        _textfield_other_property_type.textAlignment=NSTextAlignmentLeft;
        
        frame=_imgDownOne.frame;
        frame.origin.x=275;
        _imgDownOne.frame=frame;
        
        frame=_imgDownCountry.frame;
        frame.origin.x=275;
        _imgDownCountry.frame=frame;
        
        frame=_imgViewDownTWo.frame;
        frame.origin.x=275;
        _imgViewDownTWo.frame=frame;
        
        frame=_mapHolderView.frame;
        frame.origin.x=219;
        _mapHolderView.frame=frame;
        
        frame=_locationBox.frame;
        frame.origin.x=21;
        _locationBox.frame=frame;
        
        frame=_textfield_location.frame;
        frame.origin.x=28;
        _textfield_location.frame=frame;
        
        frame=_button_menu.frame;
        frame.origin.x=-20;
        _button_menu.frame=frame;
        
    }
}
@end
