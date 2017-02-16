//
//  FeedViewController.m
//  RealEstate
//
//  Created by Roman Bigun on 04/06/14.
//  Copyright (c) 2014 Roman Bigun All rights reserved.
//

#import "FeedViewController.h"
#import "FeedViewCell.h"
#import "PropertyViewController.h"
#import "UIImageView+WebCache.h"
#import "MFSideMenu.h"
#import "SearchFilterViewController.h"

@interface FeedViewController ()

@end

@implementation FeedViewController{
    
    NSMutableArray *dataArr;
    int count;
    BOOL isMore;
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
    // Do any additional setup after loading the view from its nib.
    dataArr=[[NSMutableArray alloc]init];
    count=0;
    
    self.mc=[[ModelClass alloc]init];
    self.mc.delegate=self;
    [DELEGATE addIntegration:self];

  //  [_button_searchbutton setHidden:DELEGATE.isComingFromMyListing];
    [self propertyList:0];
}
-(void)viewWillAppear:(BOOL)animated{
    [self localization];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - action methods
- (IBAction)menuClicked:(id)sender {
    if ([[USER_DEFAULTS valueForKey:@"localization"] isEqualToString:@"AR"]) {
        [self.menuContainerViewController toggleRightSideMenuCompletion:^{
            
        }];
    }else{
        [self.menuContainerViewController toggleLeftSideMenuCompletion:^{
            
        }];
    }
}
#pragma mark - Table View Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return dataArr.count;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
//@"Sell",@"",@"",@"",
-(NSString*)propertyType:(NSString*)type{
    
    if ([type isEqualToString:@"Sell"]) {
        return [LOCALIZATION localizedStringForKey:@"sell"];
    }
    if ([type isEqualToString:@"Rent"]) {
        return [LOCALIZATION localizedStringForKey:@"rent"];
    }
    if ([type isEqualToString:@"Investment"]) {
        return [LOCALIZATION localizedStringForKey:@"investment"];
    }
    return @"";
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    FeedViewCell *cell = (FeedViewCell *) [tableView dequeueReusableCellWithIdentifier:nil];
    if (cell == nil) {
        NSArray* topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"FeedViewCell" owner:self options:nil];
        for (id currentObject in topLevelObjects) {
            if ([currentObject isKindOfClass:[UITableViewCell class]]) {
                cell = (FeedViewCell *)currentObject;
                break;
            }
        }
    }
    [cell.imgProperty sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMAGE_PATH,[[dataArr objectAtIndex:indexPath.row] valueForKey:@"image"]]] placeholderImage:[UIImage imageNamed:@"home_placeholder.png"]];
    cell.lblPrice.text=[NSString stringWithFormat:@"%@ USD",[[dataArr objectAtIndex:indexPath.row]valueForKey:@"price"]];
    cell.lblTitle.text=[[dataArr objectAtIndex:indexPath.row]valueForKey:@"title"];
    cell.lblLocation.text=[[dataArr objectAtIndex:indexPath.row]valueForKey:@"location"];
    if ([[[dataArr objectAtIndex:indexPath.row]valueForKey:@"is_other"] isEqualToString:@"Y"]) {
        cell.lblType.text=[NSString stringWithFormat:@"%@",[[dataArr objectAtIndex:indexPath.row]valueForKey:@"other_value"]];
    }else{
        if ([[[dataArr objectAtIndex:indexPath.row]valueForKey:@"property_type"] isEqualToString:@"Sell"]) {
            cell.imgType.image = [UIImage imageNamed:@"ic_s"];
        }
        else if ([[[dataArr objectAtIndex:indexPath.row]valueForKey:@"property_type"] isEqualToString:@"Rent"]) {
            cell.imgType.image = [UIImage imageNamed:@"ic_r"];
        }
        else if ([[[dataArr objectAtIndex:indexPath.row]valueForKey:@"property_type"] isEqualToString:@"Investment"]) {
            cell.imgType.image = [UIImage imageNamed:@"ic_i"];
        }
        else{
            cell.imgType.image = [UIImage imageNamed:@"ic_o"];
        }
        
        if ([[NSUserDefaults standardUserDefaults] valueForKey:@"user"] && [[[dataArr objectAtIndex:indexPath.row] valueForKey:@"id"] isEqualToString:[[NSUserDefaults standardUserDefaults] valueForKey:@"userid"]]) {
            cell.lblType.text=[NSString stringWithFormat:@"%@",[self propertyType:[[dataArr objectAtIndex:indexPath.row]valueForKey:@"property_type"]]];
        }
    }
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self propertyDetail:[[dataArr objectAtIndex:indexPath.row]valueForKey:@"id"]];
}
-(void)showloader:(BOOL)isLoading{

    if (isLoading) {
        UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [spinner startAnimating];
        spinner.frame = CGRectMake(0, 0, 320, 44);
        _tblFeed.tableFooterView = spinner;
    }else{
        UILabel * footermessage = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 320, 44)];
        [footermessage setText:[LOCALIZATION localizedStringForKey:@"loading"]];
        [footermessage setTextAlignment:NSTextAlignmentCenter];
        [footermessage setTextColor:[UIColor lightGrayColor]];
        [footermessage setFont:TextFontLight(20)];
        _tblFeed.tableFooterView = footermessage;
    }
}

//Api methods
-(void)propertyList:(int)start{
    if (DELEGATE.isComingFromMyListing) {
        sUserId = [NSString stringWithFormat:@"%@",[USER_DEFAULTS valueForKeyPath:@"user.userid"]];
    }else{
        sUserId = @"0";
    }
    [self.mc propertyList:[NSString stringWithFormat:@"%d",start] forUserid:sUserId selector:@selector(propertyListFinished:)];
}
-(void)propertyListFinished:(NSDictionary*)resposne{
    
    if ([[resposne objectForKey:@"successful"] isEqualToString:@"true"]) {
        [dataArr addObjectsFromArray:[resposne valueForKey:@"Property"]];
        if ([[resposne valueForKey:@"is_last"] isEqualToString:@"Y"]) {
            isMore=NO;
        }else{
            isMore=YES;
        }
        [self.tblFeed reloadData];
        [_tblFeed setHidden:NO];
    }else{
        [_tblFeed setHidden:YES];
        
        [[[UIAlertView alloc]initWithTitle:@"Property List" message:[LOCALIZATION localizedStringForKey:@"nopropertieslisted"] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
    }
}
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
- (IBAction)searchClicked:(id)sender {
    SearchFilterViewController *detail=[[SearchFilterViewController alloc]initWithNibName:@"SearchFilterViewController" bundle:nil];
    [self.navigationController pushViewController:detail animated:YES];
}
- (IBAction)addProperty:(id)sender {
    DELEGATE.isAddingProperty = YES;
    AddPropertyViewController * apvc = [[AddPropertyViewController alloc]initWithNibName:NSStringFromClass([AddPropertyViewController class]) bundle:nil];
    [self.navigationController pushViewController:apvc animated:YES];
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    float offs = (scrollView.contentOffset.y+scrollView.bounds.size.height);
    float val = (scrollView.contentSize.height);
    
    if (offs==val)
    {
        if (isMore) {
            [self propertyList:++count];
        }
        
        [self showloader:isMore];
    }
    
}
//Localization stuffs
-(void)localization{
    [self.lblTitle setText:[LOCALIZATION localizedStringForKey:@"property"]];
    [self adjustAlignment];
}
-(void)adjustAlignment{
    CGRect frame;
    if ([[USER_DEFAULTS valueForKey:@"localization"] isEqualToString:@"AR"]) {
        
        frame=_btnMenu.frame;
        frame.origin.x=frame.origin.x=240;
        _btnMenu.frame=frame;
        
        frame=_button_searchbutton.frame;
        frame.origin.x=frame.origin.x=-20;
        _button_searchbutton.frame=frame;
        
    }else{
        
        frame=_btnMenu.frame;
        frame.origin.x=frame.origin.x=-20;
        _btnMenu.frame=frame;
        
        frame=_button_searchbutton.frame;
        frame.origin.x=frame.origin.x=240;
        _button_searchbutton.frame=frame;
    }
}

@end
