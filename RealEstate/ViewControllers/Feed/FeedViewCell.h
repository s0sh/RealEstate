//
//  FeedViewCell.h
//  RealEstate
//
//  Created by MyAppTemplates http://www.myapptemplates.com on 22/02/14.
//  Copyright (c) 2014 2014 MyAppTemplates.. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FeedViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *imgProperty;
@property (strong, nonatomic) IBOutlet UIImageView *imgType;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblLocation;
@property (weak, nonatomic) IBOutlet UILabel *lblPrice;
@property (weak, nonatomic) IBOutlet UILabel *lblType;



@end
