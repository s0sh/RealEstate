//
//  SearchResultsViewController.m
//  RealEstate
//
//  Created by macmini7 on 10/06/14.
//  Copyright (c) 2014 macmini7. All rights reserved.
//

#import "SearchResultsViewController.h"
#import "SearchResultCustomCell.h"
#import "UIAlertHelper.h"
#import "LocationServices.h"
#import "Annotations.h"
#import "UIImageView+WebCache.h"
#import "PropertyViewController.h"

@interface SearchResultsViewController ()

@end

@implementation SearchResultsViewController
@synthesize properties;

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
    [self preparemap];
    [DELEGATE addIntegration:self];
}
-(void)viewDidAppear:(BOOL)animated{
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
#pragma mark - Table View Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[properties valueForKey:@"Property"] count];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SearchResultCustomCell *cell = (SearchResultCustomCell *) [tableView dequeueReusableCellWithIdentifier:nil];
    if (cell == nil) {
        NSArray* topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"SearchResultCustomCell" owner:self options:nil];
        for (id currentObject in topLevelObjects) {
            if ([currentObject isKindOfClass:[UITableViewCell class]]) {
                cell = (SearchResultCustomCell *)currentObject;
                break;
            }
        }
    }
    [cell.imgPropertyImg sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMAGE_PATH,[[[properties valueForKey:@"Property"] objectAtIndex:indexPath.row] valueForKey:@"image_name"]]]];
    cell.lblPrice.text=[NSString stringWithFormat:@"%@ $",[[[properties valueForKey:@"Property"] objectAtIndex:indexPath.row] valueForKey:@"price"]];
    
    if ([[[[properties valueForKey:@"Property"] objectAtIndex:indexPath.row] valueForKey:@"property_type"] isEqualToString:@"S"]) {
        cell.imgType.image = [UIImage imageNamed:@"ic_s"];
    }
    else if ([[[[properties valueForKey:@"Property"] objectAtIndex:indexPath.row] valueForKey:@"property_type"] isEqualToString:@"R"]) {
        cell.imgType.image = [UIImage imageNamed:@"ic_r"];
    }
    else if ([[[[properties valueForKey:@"Property"] objectAtIndex:indexPath.row] valueForKey:@"property_type"] isEqualToString:@"I"]) {
        cell.imgType.image = [UIImage imageNamed:@"ic_i"];
    }
    else{
        cell.imgType.image = [UIImage imageNamed:@"ic_o"];
    }

    cell.lblTitle.text=[[[properties valueForKey:@"Property"] objectAtIndex:indexPath.row] valueForKey:@"title"];
    cell.lblLocation.text=[[[properties valueForKey:@"Property"] objectAtIndex:indexPath.row] valueForKey:@"location"];
   
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self propertyDetail:[[[properties valueForKey:@"Property"] objectAtIndex:indexPath.row] valueForKey:@"id"]];
}
//map
-(void)preparemap{
    
    //Remove annotation placed before
    [self removeAnnotaions];
    //Add annotations;
    for (int i=0; i<[[properties valueForKey:@"Property"] count]; i++) {
        CLLocationCoordinate2D driver;
        
        driver.latitude = [[[[properties valueForKey:@"Property"] objectAtIndex:i] valueForKey:@"latitude"] doubleValue];
        driver.longitude = [[[[properties valueForKey:@"Property"] objectAtIndex:i] valueForKey:@"longitude"] doubleValue];
        Annotations *annotaion1=[Annotations alloc];
        annotaion1.coordinate= driver;
        annotaion1.title=[NSString stringWithString:[[[properties valueForKey:@"Property"] objectAtIndex:i] valueForKey:@"title"]];
        //annotaion1.title=[NSString stringWithString:[[resultPlaces objectAtIndex:index]valueForKey:@"name"]];
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
        
    }
}
//Localization stuffs
-(void)localization{
    [self.lblTitle setText:[LOCALIZATION localizedStringForKey:@"searchresults"]];

    [self adjustAlignment];
}
-(void)adjustAlignment{
    if ([[USER_DEFAULTS valueForKey:@"localization"] isEqualToString:@"AR"]) {
    }else{
    }
}
@end
