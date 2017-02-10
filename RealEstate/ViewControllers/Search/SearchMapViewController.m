//
//  SearchMapViewController.m
//  RealEstate
//
//  Created by macmini7 on 10/06/14.
//  Copyright (c) 2014 macmini7. All rights reserved.
//

#import "SearchMapViewController.h"
#import "SearchResultsViewController.h"
#import "UIAlertHelper.h"
#import "LocationServices.h"
#import "Annotations.h"
#import "PropertyViewController.h"

@interface SearchMapViewController ()

@end

@implementation SearchMapViewController{
    
    NSMutableDictionary *properties;
    
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
  
    [self.lblTitle setFont:TextFont(22)];
    [_txtSearch setFont:TextFont(18)];
   // [_btnList.titleLabel setFont:TextFont(18)];
    [_btnRefine.titleLabel setFont:TextFont(18)];
    
    //Call api for current location
    [self searchProperty:@"" latitude:[NSString stringWithFormat:@"%f",gLocationServices.latitude] longitude:[NSString stringWithFormat:@"%f",gLocationServices.longitude]];
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
- (IBAction)btnBackClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)viewListClicked:(id)sender {
    SearchResultsViewController *detail=[[SearchResultsViewController alloc]initWithNibName:@"SearchResultsViewController" bundle:nil];
    detail.properties=[[NSMutableDictionary alloc]initWithDictionary:properties];
    [self.navigationController pushViewController:detail animated:YES];
}
- (IBAction)searchClicked:(id)sender {
    [_txtSearch resignFirstResponder];
    if (self.txtSearch.text.length<1 ||[DELEGATE trimWhiteSpaces:self.txtSearch.text].length<1) {
        [UIAlertHelper showAlert:[LOCALIZATION localizedStringForKey:@"entersearchlocation"]];
        _txtSearch.text=@"";
        return;
    }
    [self searchProperty:[DELEGATE trimWhiteSpaces:self.txtSearch.text] latitude:@"" longitude:@""];
}
- (IBAction)listClicked:(id)sender {
   
}
//Api methods
-(void)searchProperty:(NSString*)searchtext latitude:(NSString*)latitude longitude:(NSString*)longitude{
    
    [self.mc searchProperty:searchtext latitude:latitude longitude:longitude selector:@selector(searchPropertyFinished:)];
}
-(void)searchPropertyFinished:(NSDictionary*)response{
    if (_txtSearch.text.length>1) {
        _txtSearch.text=@"";
    }
    if ([[response valueForKey:@"successful"] isEqualToString:@"true"]) {
        if (properties) {
            properties=[NSMutableDictionary dictionaryWithDictionary:response];
        }else{
            properties=[[NSMutableDictionary alloc]initWithDictionary:response];
        }
        [self preparemap];
    }else{
        [UIAlertHelper showAlert:[response valueForKey:@"message"]];
    }
}

//map
-(void)preparemap{
    
    //Remove annotation placed before
    [self removeAnnotaions];
    //Add annotations;
    for (int i=0; i<[[properties valueForKey:@"Property"] count]; i++) {
        CLLocationCoordinate2D proPlace;
        proPlace.latitude = [[[[properties valueForKey:@"Property"] objectAtIndex:i] valueForKey:@"latitude"] doubleValue];
        proPlace.longitude = [[[[properties valueForKey:@"Property"] objectAtIndex:i] valueForKey:@"longitude"] doubleValue];
        if ((proPlace.latitude<-90 || proPlace.latitude>90)||(proPlace.longitude<-180 || proPlace.longitude>180)) {
            continue;
        }
        Annotations *annotaion1=[Annotations alloc];
        annotaion1.coordinate= proPlace;
        annotaion1.title=[NSString stringWithString:[[[properties valueForKey:@"Property"] objectAtIndex:i] valueForKey:@"title"]];
        annotaion1.place_id=[NSString stringWithString:[[[properties valueForKey:@"Property"] objectAtIndex:i] valueForKey:@"id"]];
        [self.mapPropperties addAnnotation:annotaion1];
    }
    [self zoomToFitMapAnnotations:self.mapPropperties];
}
//Remove previously added annotation
-(void)removeAnnotaions{
    NSInteger toRemoveCount = self.mapPropperties.annotations.count;
    NSMutableArray *toRemove = [NSMutableArray arrayWithCapacity:toRemoveCount];
    for (id annotation in self.mapPropperties.annotations)
        if (annotation != self.mapPropperties.userLocation)
            [toRemove addObject:annotation];
    [self.mapPropperties removeAnnotations:toRemove];
}
//Annotation Image change
- (MKAnnotationView *)mapView:(MKMapView *)map viewForAnnotation:(id <MKAnnotation>)annotation
{
    static NSString *annotationViewReuseIdentifier = @"annotationViewReuseIdentifier";
    MKAnnotationView *annotationView = (MKAnnotationView *)[self.mapPropperties dequeueReusableAnnotationViewWithIdentifier:annotationViewReuseIdentifier];
    if (annotationView == nil)
    {
        annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:annotationViewReuseIdentifier];
    }
    annotationView.image = [UIImage imageNamed:@"mapPin.png"];
    annotationView.annotation = annotation;
    annotationView.canShowCallout = YES;
    UIButton *detailButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    annotationView.rightCalloutAccessoryView = detailButton;
    
    return annotationView;
}

//Zoom to fit annotations
- (void)zoomToFitMapAnnotations:(MKMapView *)mapView {
    if ([mapView.annotations count] == 0) return;
    
    CLLocationCoordinate2D topLeftCoord;
    topLeftCoord.latitude = -90;
    topLeftCoord.longitude = 180;
    
    CLLocationCoordinate2D bottomRightCoord;
    bottomRightCoord.latitude = 90;
    bottomRightCoord.longitude = -180;
    
    for(id<MKAnnotation> annotation in mapView.annotations) {
        topLeftCoord.longitude = fmin(topLeftCoord.longitude, annotation.coordinate.longitude);
        topLeftCoord.latitude = fmax(topLeftCoord.latitude, annotation.coordinate.latitude);
        bottomRightCoord.longitude = fmax(bottomRightCoord.longitude, annotation.coordinate.longitude);
        bottomRightCoord.latitude = fmin(bottomRightCoord.latitude, annotation.coordinate.latitude);
    }
    
    MKCoordinateRegion region;
    region.center.latitude = topLeftCoord.latitude - (topLeftCoord.latitude - bottomRightCoord.latitude) * 0.5;
    region.center.longitude = topLeftCoord.longitude + (bottomRightCoord.longitude - topLeftCoord.longitude) * 0.5;
    region.span.latitudeDelta = fabs(topLeftCoord.latitude - bottomRightCoord.latitude) * 1.1; // Add a little extra space on the sides
    region.span.longitudeDelta = fabs(bottomRightCoord.longitude - topLeftCoord.longitude) * 1.1; // Add a little extra space on the sides
    
    region = [mapView regionThatFits:region];
    [mapView setRegion:region animated:YES];
}
//textfield delegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    if (self.txtSearch.text.length<1 ||[DELEGATE trimWhiteSpaces:self.txtSearch.text].length<1) {
        [UIAlertHelper showAlert:@"Please enter location"];
        _txtSearch.text=@"";
        
    }else
        [self searchProperty:[DELEGATE trimWhiteSpaces:self.txtSearch.text] latitude:@"" longitude:@""];
    
    return YES;
}
- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view
calloutAccessoryControlTapped:(UIControl *)control{
    [self.view endEditing:YES];
    Annotations *temp=view.annotation;
    [self propertyDetail:temp.place_id];
    
}
//api methods
-(void)propertyDetail:(NSString*)property_id{
    [self.mc propertyDetails:property_id selector:@selector(propertyDetailFinished:)];
}
-(void)propertyDetailFinished:(NSDictionary*)resposne{
    
    if ([[resposne valueForKey:@"successful"] isEqualToString:@"true"]) {
        PropertyViewController *detail=[[PropertyViewController alloc]initWithNibName:@"PropertyViewController" bundle:nil];
        detail.response=[[NSMutableDictionary alloc]initWithDictionary:resposne];
        [self.navigationController pushViewController:detail animated:YES];
        
    }else{
        [UIAlertHelper showAlert:@"Fetching property details failed !"];
    }
}
//Localization stuffs
-(void)localization{
//    [self.lblTitle setText:[LOCALIZATION localizedStringForKey:@"map"]];
//    [self.btnRefine setTitle:[LOCALIZATION localizedStringForKey:@"redefine"] forState:UIControlStateNormal];
//    [self.btnList setTitle:[LOCALIZATION localizedStringForKey:@"list"] forState:UIControlStateNormal];
//    _txtSearch.placeholder=[LOCALIZATION localizedStringForKey:@"searchlcoation"];
    //[self adjustAlignment];
}
-(void)adjustAlignment{
    if ([[USER_DEFAULTS valueForKey:@"localization"] isEqualToString:@"AR"]) {
        _txtSearch.textAlignment=NSTextAlignmentRight;
    }else{
        _txtSearch.textAlignment=NSTextAlignmentLeft;
    }
}


@end
