//
//  FeedViewController.h
//  RealEstate
//
//  Created by Roman Bigun on 04/06/14.
//  Copyright (c) 2014 Roman Bigun All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ModelClass.h"
#import "AddPropertyViewController.h"


@interface FeedViewController : UIViewController{
    NSString * sUserId;
}
@property(strong)ModelClass *mc;
@property (strong, nonatomic) IBOutlet UITableView *tblFeed;
@property (weak, nonatomic) IBOutlet UIButton *button_searchbutton;
@property (weak, nonatomic) IBOutlet UIButton *button_addproperty;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
- (IBAction)searchClicked:(id)sender;
- (IBAction)addProperty:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *btnMenu;
@property (weak, nonatomic) IBOutlet UIButton *btnSearch;




@end
