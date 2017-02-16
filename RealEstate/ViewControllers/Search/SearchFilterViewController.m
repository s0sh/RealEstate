//
//  SearchFilterViewController.m
//  RealEstate
//
//  Created by Roman Bigun on 10/06/14.
//  Copyright (c) 2014 Roman Bigun All rights reserved.
//

#import "SearchFilterViewController.h"
#import "SearchMapViewController.h"
#import "UIAlertHelper.h"
#import "SearchResultsViewController.h"

@interface SearchFilterViewController ()

@end

@implementation SearchFilterViewController{
    NSMutableArray * keyboardfieldsArray;
    CGRect frmOther;
    CGRect frmNotOther;
    NSString *propertyType;
    NSString *zoning;
    BOOL isOther;
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
    
    [self.scroll addSubview:self.containerView];
    [self.scroll setContentSize:CGSizeMake(320, self.containerView.frame.size.height+50)];
    [self setFontsAndInit];
    //Call bskeyboard settings
    [self bsKeyboardSetting];
    [DELEGATE addIntegration:self];
    UIColor *color = [UIColor colorWithRed:145.0/255.0 green:145.0/255.0 blue:145.0/255.0 alpha:1.0 ];
    _txtStartPrice.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Email" attributes:@{NSForegroundColorAttributeName: color}];
    _txtEndPrice.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Password" attributes:@{NSForegroundColorAttributeName: color}];
    _txtLocation.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Email" attributes:@{NSForegroundColorAttributeName: color}];
    _txtOther.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Password" attributes:@{NSForegroundColorAttributeName: color}];
}
-(void)viewWillAppear:(BOOL)animated{
    [self localization];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btnBackClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)searchMapClicked:(id)sender {
    SearchMapViewController *deatil=[[SearchMapViewController alloc]initWithNibName:@"SearchMapViewController" bundle:nil];
    [self.navigationController pushViewController:deatil animated:YES];
}


//Setfonts and init slection
-(void)setFontsAndInit{
    
    isOther=NO;
    self.mc=[[ModelClass alloc]init];
    self.mc.delegate=self;
    [self.lblTitle setFont:TextFont(22)];
    [_btnSearchFilter.titleLabel setFont:TextFont(18)];
    [_txtStartPrice setFont:TextFontLight(18)];
    [_txtEndPrice setFont:TextFontLight(18)];
    [_txtLocation setFont:TextFontLight(18)];
    [_txtOther setFont:TextFontLight(18)];
    
    propertyType=@"A";
    zoning=@"A";
    _btnTypeAll.selected=YES;
    _btnTypeSell.selected=NO;
    _btnTypeRent.selected=NO;
    _btnTypeInvest.selected=NO;
    _btnTypeOther.selected=NO;
    _btnZoneAll.selected=YES;
    _btnZoneResidential.selected=NO;
    _btnZoneCommercial.selected=NO;
    _btnZoneRetail.selected=NO;
    _btnZoneMixed.selected=NO;
    
    CGRect frame=self.buttomView.frame;
    frmOther=frame;
    frame.origin.y=frame.origin.y-54;
    frmNotOther=frame;
    self.buttomView.frame=frmNotOther;
    
    
}

- (IBAction)typeClicked:(UIButton *)sender {
    if (sender==_btnTypeSell) {
        _btnTypeSell.selected=YES;
        _btnTypeRent.selected=NO;
        _btnTypeInvest.selected=NO;
        _btnTypeOther.selected=NO;
        _btnTypeAll.selected=NO;
        propertyType=@"S";
         self.buttomView.frame=frmNotOther;
        isOther=NO;
    }else if (sender==_btnTypeAll) {
        _btnTypeAll.selected=YES;
        _btnTypeSell.selected=NO;
        _btnTypeRent.selected=NO;
        _btnTypeInvest.selected=NO;
        _btnTypeOther.selected=NO;
        propertyType=@"A";
        self.buttomView.frame=frmNotOther;
        isOther=NO;
    }else if (sender==_btnTypeRent) {
        _btnTypeAll.selected=NO;
        _btnTypeSell.selected=NO;
        _btnTypeRent.selected=YES;
        _btnTypeInvest.selected=NO;
        _btnTypeOther.selected=NO;
        propertyType=@"R";
        self.buttomView.frame=frmNotOther;
        isOther=NO;
    }else if (sender==_btnTypeInvest) {
        _btnTypeAll.selected=NO;
        _btnTypeSell.selected=NO;
        _btnTypeRent.selected=NO;
        _btnTypeInvest.selected=YES;
        _btnTypeOther.selected=NO;
        propertyType=@"I";
        self.buttomView.frame=frmNotOther;
        isOther=NO;
    }else if (sender==_btnTypeOther) {
        _btnTypeAll.selected=NO;
        _btnTypeSell.selected=NO;
        _btnTypeRent.selected=NO;
        _btnTypeInvest.selected=NO;
        _btnTypeOther.selected=YES;
        propertyType=@"O";
        self.buttomView.frame=frmOther;
        isOther=YES;
    }
}

- (IBAction)zoneClicked:(UIButton *)sender {
    if (sender==_btnZoneResidential) {
        _btnZoneResidential.selected=YES;
        _btnZoneAll.selected=NO;
        _btnZoneCommercial.selected=NO;
        _btnZoneRetail.selected=NO;
        _btnZoneMixed.selected=NO;
        zoning=@"R";
    }else if (sender==_btnZoneAll) {
        _btnZoneAll.selected=YES;
        _btnZoneResidential.selected=NO;
        _btnZoneCommercial.selected=NO;
        _btnZoneRetail.selected=NO;
        _btnZoneMixed.selected=NO;
        zoning=@"A";
    }else if (sender==_btnZoneCommercial) {
        _btnZoneAll.selected=NO;
        _btnZoneResidential.selected=NO;
        _btnZoneCommercial.selected=YES;
        _btnZoneRetail.selected=NO;
        _btnZoneMixed.selected=NO;
        zoning=@"C";
    }else if (sender==_btnZoneRetail) {
        _btnZoneAll.selected=NO;
        _btnZoneResidential.selected=NO;
        _btnZoneCommercial.selected=NO;
        _btnZoneRetail.selected=YES;
        _btnTypeOther.selected=NO;
        zoning=@"RT";
    }else if (sender==_btnZoneMixed) {
        _btnZoneAll.selected=NO;
        _btnZoneResidential.selected=NO;
        _btnZoneCommercial.selected=NO;
        _btnZoneRetail.selected=NO;
        _btnZoneMixed.selected=YES;
        zoning=@"M";
    }
}

- (IBAction)searchClciked:(id)sender {
   
    if (isOther) {
        
    if (self.txtOther.text.length<1 ||[DELEGATE trimWhiteSpaces:self.txtOther.text].length<1) {
            [UIAlertHelper showAlert:@"Please enter value for other type !"];
            return;
        }
    
    [self searchFilters:[DELEGATE trimWhiteSpaces:self.txtStartPrice.text] price_to:[DELEGATE trimWhiteSpaces:self.txtEndPrice.text] location:[DELEGATE trimWhiteSpaces:self.txtLocation.text] property_type:propertyType other_type:@"Y" other_value:[DELEGATE trimWhiteSpaces:self.txtOther.text] zoning:zoning];
        
    }else{
        
         [self searchFilters:[DELEGATE trimWhiteSpaces:self.txtStartPrice.text] price_to:[DELEGATE trimWhiteSpaces:self.txtEndPrice.text] location:[DELEGATE trimWhiteSpaces:self.txtLocation.text] property_type:propertyType other_type:@"N" other_value:@"" zoning:zoning];
    }
}
//BS keyboard settings
-(void)bsKeyboardSetting{
    
    keyboardfieldsArray = [NSMutableArray arrayWithObjects:
                           _txtStartPrice,
                           _txtEndPrice,_txtLocation,_txtOther,_txtOther, nil];
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
//Api methods
-(void)searchFilters:(NSString *)price_from
            price_to:(NSString*)price_to
            location:(NSString*)location
       property_type:(NSString*)property_type
          other_type:(NSString*)other_type
         other_value:(NSString*)other_value
              zoning:(NSString*)zoning1{
    
    [self.mc searchFilter:price_from price_to:price_to location:location property_type:property_type other_type:other_type other_value:other_value zoning:zoning1 selector:@selector(searchFiltersFinish:)];
}
-(void)searchFiltersFinish:(NSDictionary*)response{
    if ([[response valueForKey:@"successful"] isEqualToString:@"true"]) {
        [self clean];
        SearchResultsViewController *detail=[[SearchResultsViewController alloc]initWithNibName:@"SearchResultsViewController" bundle:nil];
        detail.properties=[[NSMutableDictionary alloc]initWithDictionary:response];
        [self.navigationController pushViewController:detail animated:YES];
    }else{
       [UIAlertHelper showAlert:[response valueForKey:@"message"]];
    }
}
-(void)clean{
    
    self.txtStartPrice.text=@"";
    self.txtEndPrice.text=@"";
    self.txtLocation.text=@"";
    self.txtOther.text=@"";
    isOther=NO;
    propertyType=@"A";
    zoning=@"A";
    _btnTypeAll.selected=YES;
    _btnTypeSell.selected=NO;
    _btnTypeRent.selected=NO;
    _btnTypeInvest.selected=NO;
    _btnTypeOther.selected=NO;
    _btnZoneResidential.selected=NO;
    _btnZoneCommercial.selected=NO;
    _btnZoneRetail.selected=NO;
    _btnZoneMixed.selected=NO;
    _btnZoneAll.selected=YES;
    self.buttomView.frame=frmNotOther;

    
}
//Localization stuffs

-(void)localization{
    [self.lblTitle setText:[LOCALIZATION localizedStringForKey:@"searchoptions"]];
    [self.btnSearchFilter setTitle:[LOCALIZATION localizedStringForKey:@"search"] forState:UIControlStateNormal];
    _txtStartPrice.placeholder=[LOCALIZATION localizedStringForKey:@"startprice"];
    _txtEndPrice.placeholder=[LOCALIZATION localizedStringForKey:@"endprice"];
    _txtLocation.placeholder=[LOCALIZATION localizedStringForKey:@"location"];
    _txtOther.placeholder=[LOCALIZATION localizedStringForKey:@"other"];
    _lblPropertyTypeCap.text=[LOCALIZATION localizedStringForKey:@"propertytype"];
    _lblZoninigCap.text=[LOCALIZATION localizedStringForKey:@"zoninig"];
    
    _lblProAll.text=[LOCALIZATION localizedStringForKey:@"all"];
    _lblProinvestment.text=[LOCALIZATION localizedStringForKey:@"investment"];
    _lblProRent.text=[LOCALIZATION localizedStringForKey:@"rent"];
    _lblProSell.text=[LOCALIZATION localizedStringForKey:@"sell"];
    _lblProOther.text=[LOCALIZATION localizedStringForKey:@"other"];
    
    _lblZoAll.text=[LOCALIZATION localizedStringForKey:@"all"];
    _lblZoRetail.text=[LOCALIZATION localizedStringForKey:@"retail"];
    _lblZoCommercial.text=[LOCALIZATION localizedStringForKey:@"commercial"];
    _lblZoMixed.text=[LOCALIZATION localizedStringForKey:@"mixed"];
    _lblZoResidential.text=[LOCALIZATION localizedStringForKey:@"residential"];
    
    [self adjustAlignment];
}
-(void)adjustAlignment{
    CGRect frame;
 
    if ([[USER_DEFAULTS valueForKey:@"localization"] isEqualToString:@"AR"]) {
        _txtStartPrice.textAlignment=NSTextAlignmentRight;
        _txtEndPrice.textAlignment=NSTextAlignmentRight;
        _txtLocation.textAlignment=NSTextAlignmentRight;
        _txtOther.textAlignment=NSTextAlignmentRight;
        frame=_lblPropertyTypeCap.frame;
        frame.origin.x=frame.origin.x=180;
        _lblPropertyTypeCap.frame=frame;
        _lblPropertyTypeCap.textAlignment=NSTextAlignmentRight;
        
        frame=_lblZoninigCap.frame;
        frame.origin.x=frame.origin.x=180;
        _lblZoninigCap.frame=frame;
        _lblZoninigCap.textAlignment=NSTextAlignmentRight;
        
        frame=_btnTypeAll.frame;
        frame.origin.x=frame.origin.x=100;
        _btnTypeAll.frame=frame;
        
        frame=_btnTypeSell.frame;
        frame.origin.x=frame.origin.x=100;
        _btnTypeSell.frame=frame;
        
        frame=_btnTypeOther.frame;
        frame.origin.x=frame.origin.x=248;
        _btnTypeOther.frame=frame;
        
        frame=_btnTypeRent.frame;
        frame.origin.x=frame.origin.x=248;
        _btnTypeRent.frame=frame;
        
        frame=_btnTypeInvest.frame;
        frame.origin.x=frame.origin.x=248;
        _btnTypeInvest.frame=frame;
        
        //-
        frame=_lblProAll.frame;
        frame.origin.x=frame.origin.x=55;
        _lblProAll.frame=frame;
        _lblProAll.textAlignment=NSTextAlignmentRight;
        
        frame=_lblProSell.frame;
        frame.origin.x=frame.origin.x=46;
        _lblProSell.frame=frame;
        _lblProSell.textAlignment=NSTextAlignmentRight;
        
        frame=_lblProOther.frame;
        frame.origin.x=frame.origin.x=155;
        _lblProOther.frame=frame;
        _lblProOther.textAlignment=NSTextAlignmentRight;
        
        frame=_lblProRent.frame;
        frame.origin.x=frame.origin.x=199;
        _lblProRent.frame=frame;
        _lblProRent.textAlignment=NSTextAlignmentRight;
        
        frame=_lblProinvestment.frame;
        frame.origin.x=frame.origin.x=155;
        _lblProinvestment.frame=frame;
        _lblProinvestment.textAlignment=NSTextAlignmentRight;
        
        //-zpne btn
        frame=_btnZoneAll.frame;
        frame.origin.x=frame.origin.x=100;
        _btnZoneAll.frame=frame;
        
        frame=_btnZoneCommercial.frame;
        frame.origin.x=frame.origin.x=100;
        _btnZoneCommercial.frame=frame;
        
        frame=_btnZoneMixed.frame;
        frame.origin.x=frame.origin.x=248;
        _btnZoneMixed.frame=frame;
        
        frame=_btnZoneResidential.frame;
        frame.origin.x=frame.origin.x=248;
        _btnZoneResidential.frame=frame;
        
        frame=_btnZoneRetail.frame;
        frame.origin.x=frame.origin.x=248;
        _btnZoneRetail.frame=frame;
        
        
        //-zone lbl
        frame=_lblZoAll.frame;
        frame.origin.x=frame.origin.x=60;
        _lblZoAll.frame=frame;
        _lblZoAll.textAlignment=NSTextAlignmentRight;
        
        frame=_lblZoCommercial.frame;
        frame.origin.x=frame.origin.x=0;
        _lblZoCommercial.frame=frame;
        _lblZoCommercial.textAlignment=NSTextAlignmentRight;
        
        frame=_lblZoMixed.frame;
        frame.origin.x=frame.origin.x=153;
        _lblZoMixed.frame=frame;
        _lblZoMixed.textAlignment=NSTextAlignmentRight;
        
        frame=_lblZoResidential.frame;
        frame.origin.x=frame.origin.x=140;
        _lblZoResidential.frame=frame;
        _lblZoResidential.textAlignment=NSTextAlignmentRight;
        
        frame=_lblZoRetail.frame;
        frame.origin.x=frame.origin.x=197;
        _lblZoRetail.frame=frame;
        _lblZoRetail.textAlignment=NSTextAlignmentRight;
        
        
        
    }else{
        _txtStartPrice.textAlignment=NSTextAlignmentLeft;
        _txtEndPrice.textAlignment=NSTextAlignmentLeft;
        _txtLocation.textAlignment=NSTextAlignmentLeft;
        _txtOther.textAlignment=NSTextAlignmentLeft;
        
        frame=_lblPropertyTypeCap.frame;
        frame.origin.x=frame.origin.x=20;
        _lblPropertyTypeCap.frame=frame;
        _lblPropertyTypeCap.textAlignment=NSTextAlignmentLeft;
        
        frame=_lblZoninigCap.frame;
        frame.origin.x=frame.origin.x=20;
        _lblZoninigCap.frame=frame;
        _lblZoninigCap.textAlignment=NSTextAlignmentLeft;
        
        frame=_btnTypeAll.frame;
        frame.origin.x=frame.origin.x=50;
        _btnTypeAll.frame=frame;
        
        frame=_btnTypeSell.frame;
        frame.origin.x=frame.origin.x=50;
        _btnTypeSell.frame=frame;
        
        frame=_btnTypeOther.frame;
        frame.origin.x=frame.origin.x=50;
        _btnTypeOther.frame=frame;
        
        frame=_btnTypeRent.frame;
        frame.origin.x=frame.origin.x=196;
        _btnTypeRent.frame=frame;
        
        frame=_btnTypeInvest.frame;
        frame.origin.x=frame.origin.x=196;
        _btnTypeInvest.frame=frame;
        
        //--
        
        frame=_lblProAll.frame;
        frame.origin.x=frame.origin.x=75;
        _lblProAll.frame=frame;
        _lblProAll.textAlignment=NSTextAlignmentLeft;
        
        frame=_lblProSell.frame;
        frame.origin.x=frame.origin.x=75;
        _lblProSell.frame=frame;
        _lblProSell.textAlignment=NSTextAlignmentLeft;
        
        frame=_lblProOther.frame;
        frame.origin.x=frame.origin.x=75;
        _lblProOther.frame=frame;
        _lblProOther.textAlignment=NSTextAlignmentLeft;
        
        frame=_lblProRent.frame;
        frame.origin.x=frame.origin.x=223;
        _lblProRent.frame=frame;
        _lblProRent.textAlignment=NSTextAlignmentLeft;
        
        frame=_lblProinvestment.frame;
        frame.origin.x=frame.origin.x=223;
        _lblProinvestment.frame=frame;
        _lblProinvestment.textAlignment=NSTextAlignmentLeft;
        
        //--zone btn
        frame=_btnZoneAll.frame;
        frame.origin.x=frame.origin.x=50;
        _btnZoneAll.frame=frame;
        
        frame=_btnZoneCommercial.frame;
        frame.origin.x=frame.origin.x=50;
        _btnZoneCommercial.frame=frame;
        
        frame=_btnZoneMixed.frame;
        frame.origin.x=frame.origin.x=50;
        _btnZoneMixed.frame=frame;
        
        frame=_btnZoneResidential.frame;
        frame.origin.x=frame.origin.x=196;
        _btnZoneResidential.frame=frame;
        
        frame=_btnZoneRetail.frame;
        frame.origin.x=frame.origin.x=196;
        _btnZoneRetail.frame=frame;
        
        //-zone lbl
        frame=_lblZoAll.frame;
        frame.origin.x=frame.origin.x=75;
        _lblZoAll.frame=frame;
        _lblZoAll.textAlignment=NSTextAlignmentLeft;
        
        frame=_lblZoCommercial.frame;
        frame.origin.x=frame.origin.x=75;
        _lblZoCommercial.frame=frame;
        _lblZoCommercial.textAlignment=NSTextAlignmentLeft;
        
        frame=_lblZoMixed.frame;
        frame.origin.x=frame.origin.x=75;
        _lblZoMixed.frame=frame;
        _lblZoMixed.textAlignment=NSTextAlignmentLeft;
        
        frame=_lblZoResidential.frame;
        frame.origin.x=frame.origin.x=223;
        _lblZoResidential.frame=frame;
        _lblZoResidential.textAlignment=NSTextAlignmentLeft;
        
        frame=_lblZoRetail.frame;
        frame.origin.x=frame.origin.x=223;
        _lblZoRetail.frame=frame;
        _lblZoRetail.textAlignment=NSTextAlignmentLeft;
        
    }
}
@end
