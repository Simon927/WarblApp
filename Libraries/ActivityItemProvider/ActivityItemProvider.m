//
//  ActivityItemProvider.m
//  Warbl
//
//  Created by Xin ZhangZhe on 4/3/14.
//  Copyright (c) 2014 sptmbr LLC. All rights reserved.
//
// --- Headers ---;
#import "ActivityItemProvider.h"

// --- Defines ---;
// ActivityItemProvider Class;
@implementation ActivityItemProvider

// Functions;
#pragma mark - ActivityItemProvider
- (id)activityViewController:(UIActivityViewController *)activityViewController itemForActivityType:(NSString *)activityType
{
    if ([activityType isEqualToString:UIActivityTypePostToFacebook]) {
        return [NSString stringWithFormat:@"Watch %@ on #Warbl Download the app @", self.placeholderItem];
    } else if ([activityType isEqualToString:UIActivityTypePostToTwitter]) {
        return [NSString stringWithFormat:@"Watch %@ on #Warbl Download the app @", self.placeholderItem];
    } else if ([activityType isEqualToString:UIActivityTypeMail]) {
        return [NSString stringWithFormat:@"Watch %@ on Warbl\n It's a great new iPhone app for finding YouTube videos that matter to you and your friends", self.placeholderItem];
    } else if ([activityType isEqualToString:UIActivityTypeMessage]) {
        return [NSString stringWithFormat:@"Watch %@ on Warbl @", self.placeholderItem];
    }
    
    return nil;
}

@end
