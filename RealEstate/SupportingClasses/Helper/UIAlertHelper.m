//
//  UIAlertHelper.m
//  sortedfoodies
//
//  Created by Hai on 9/11/13.
//  Copyright (c) 2013 Hai. All rights reserved.
//

#import "UIAlertHelper.h"

@implementation UIAlertHelper

+ (void)showAlert:(NSString*)alert{
    NSString *capitalized = [[[alert substringToIndex:1] uppercaseString] stringByAppendingString:[alert substringFromIndex:1]];
    UIAlertView *anAlert = [[UIAlertView alloc] initWithTitle:@"Erminesoft" message:capitalized delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [anAlert show];
}

@end
