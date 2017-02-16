//
//  AddPropertyViewController.h
//  RealEstate
//
//  Created by Peerbits on 17/06/14.
//  Copyright (c) 2014 Roman Bigun All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TPKeyboardAvoidingScrollView.h"
#import "BSKeyboardControls.h"
#import "ModelClass.h"
#import "MFSideMenu.h"
#import "FeedViewController.h"
#import "UIButton+WebCache.h"
#import "SMTagField.h"
#import <MapKit/MapKit.h>
#import "PeerTextfield.h"
#import <CoreLocation/CoreLocation.h>
@interface AddPropertyViewController : UIViewController<BSKeyboardControlsDelegate, UIPickerViewDelegate, UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate, UITextViewDelegate, SMTagFieldDelegate,MKMapViewDelegate,CLLocationManagerDelegate,CLLocationManagerDelegate>{
    
    NSMutableArray * keyboardfieldsArray, * pickerArray, * propertytypeArray, * zoningArray;
    NSString *sPropertyId, * sUserId, * sTitle, * sPrice, * sLocation, * sCity, * sState, * sCountry, * sZipcode, * sPropertyType, * sOtherPropertyType, * sZoning, * sSearchTag, * sDescription;
    NSString * alerttitle, * alertmessage;
    BOOL isPropertyPicker, isZoningPicker, isCountryPicker;
    NSInteger uploadphoto_buttonindex;
    NSMutableArray * propertyImagesArray;
    NSMutableDictionary * propertyImageDictionary;
    CGFloat x,y,w,h;
    NSMutableArray * tagsArray;
    NSArray *countriesENArray;
    NSArray *countriesARArray;
    NSArray *appLngCountriesArray;
    CLLocationManager *locationManager;
    CLLocation *curLocation;
    __block NSString *whereAmI;
    __block CLPlacemark *placemark;
}

@property (strong, nonatomic) IBOutlet TPKeyboardAvoidingScrollView * scroll_add_property_view;
@property(strong)ModelClass *mc;
@property (nonatomic, strong) BSKeyboardControls *keyboardControls;
@property (retain, nonatomic) IBOutlet UIAlertView *alert_delete_property;
@property (weak, nonatomic) IBOutlet UIButton *button_deleteproperty;
@property (weak, nonatomic) IBOutlet UILabel *label_currency;
@property (weak, nonatomic) IBOutlet UITextField *textfield_title;
@property (weak, nonatomic) IBOutlet UITextField *textfield_price;
@property (weak, nonatomic) IBOutlet UITextField *textfield_location;
@property (weak, nonatomic) IBOutlet UITextField *textfield_city;
@property (weak, nonatomic) IBOutlet UITextField *textfield_state;
@property (weak, nonatomic) IBOutlet PeerTextfield *textfield_country;
@property (weak, nonatomic) IBOutlet PeerTextfield *textfield_property_type;
@property (weak, nonatomic) IBOutlet PeerTextfield *textfield_zoning;
@property (weak, nonatomic) IBOutlet UITextField *textfield_other_property_type;
@property (weak, nonatomic) IBOutlet SMTagField *textfield_search_tag;
@property (weak, nonatomic) IBOutlet UITextView *textview_description;
@property (weak, nonatomic) IBOutlet UIButton *addNEditProperty;
@property (strong, nonatomic) IBOutlet UIPickerView *picker_PropertyZoning;
@property (strong, nonatomic) IBOutlet UIPickerView *picker_PropertyCountries;
@property (weak, nonatomic) IBOutlet UIButton *button_one_property_image;
@property (weak, nonatomic) IBOutlet UIButton *button_two_property_image;
@property (weak, nonatomic) IBOutlet UIButton *button_three_property_image;
@property (weak, nonatomic) IBOutlet UITextField *textfield_zipcode;
@property (weak, nonatomic) IBOutlet UIView *view_add_otherproperty_view;
@property (strong, nonatomic) NSMutableDictionary * property_detail_dictionary;
@property (weak, nonatomic) IBOutlet UILabel *label_header_addproperty;
@property (weak, nonatomic) IBOutlet UIButton *button_menu;
@property (weak, nonatomic) IBOutlet UIButton *button_back;
@property (weak, nonatomic) IBOutlet UILabel *lblDescriptionCaption;
@property (weak, nonatomic) IBOutlet UILabel *lblPropertyCaption;
@property (strong, nonatomic) IBOutlet UIView *viewMap;
@property (weak, nonatomic) IBOutlet UIButton *btnCurrentlocation;
@property (weak, nonatomic) IBOutlet UIButton *btnApply;
@property (weak, nonatomic) IBOutlet UILabel *lblNoteLongPress;
@property (weak, nonatomic) IBOutlet MKMapView *mapPropertyLocation;
@property (weak, nonatomic) IBOutlet UIView *viewContainer;
- (IBAction)btnApplyClicked:(id)sender;
- (IBAction)currentLocationClicked:(id)sender;
- (IBAction)propetyPhoto:(UIButton *)sender;
- (IBAction)addNEditProperty:(id)sender;
- (IBAction)backNavigation:(id)sender;
- (IBAction)openPickerView:(UIButton *)sender;
- (IBAction)deleteProperty:(id)sender;
- (IBAction)menuClicked:(id)sender;
- (IBAction)showMapClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *cancelClicked;
- (IBAction)cancelClicked:(id)sender;
- (IBAction)proTypeEndEditing:(UITextField *)sender;
- (IBAction)proZoningEndEdting:(id)sender;
@property (strong, nonatomic) IBOutlet UIView *photoStep2;
@property (strong, nonatomic) IBOutlet UIView *photoStep3;
@property (weak, nonatomic) IBOutlet UIButton *_button_four_property_image;
@property (weak, nonatomic) IBOutlet UIButton *_button_five_property_image;
@property (weak, nonatomic) IBOutlet UIButton *_button_six_property_image;
@property (weak, nonatomic) IBOutlet UIButton *_button_seven_property_image;
@property (weak, nonatomic) IBOutlet UIButton *_button_eight_property_image;
@property (weak, nonatomic) IBOutlet UIButton *_button_nine_property_image;
@property (weak, nonatomic) IBOutlet UIImageView *imgDownOne;
@property (weak, nonatomic) IBOutlet UIImageView *imgDownCountry;
@property (weak, nonatomic) IBOutlet UIImageView *imgViewDownTWo;
@property (weak, nonatomic) IBOutlet UIImageView *locationBox;
@property (weak, nonatomic) IBOutlet UIView *mapHolderView;
@end
