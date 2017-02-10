//
//  PeerTextfield.m
//  RealEstate
//
//  Created by macmini7 on 09/07/14.
//  Copyright (c) 2014 macmini7. All rights reserved.
//

#import "PeerTextfield.h"

@implementation PeerTextfield

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/
- (BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    if (action == @selector(paste:))
        return NO;
    return [super canPerformAction:action withSender:sender];
}
@end
