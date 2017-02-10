//
//  SearchResultCustomCell.h
//  RealEstate
//
//  Created by MyAppTemplates http://www.myapptemplates.com on 22/02/14.
//  Copyright (c) 2014 2014 MyAppTemplates.. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchResultCustomCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *imgType;
@property (strong, nonatomic) IBOutlet UIImageView *imgPropertyImg;
@property (strong, nonatomic) IBOutlet UILabel *lblPrice;
@property (strong, nonatomic) IBOutlet UILabel *lblType;
@property (strong, nonatomic) IBOutlet UILabel *lblTitle;
@property (strong, nonatomic) IBOutlet UILabel *lblLocation;


@end
