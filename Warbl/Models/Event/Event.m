//
//  Event.m
//  Warbl
//
//  Created by Xin ZhangZhe on 4/3/14.
//  Copyright (c) 2014 Xin ZhangZhe. All rights reserved.
//
// --- Headers ---;
#import "Event.h"
#import "User.h"
#import "Video.h"

// --- Defines ---;
// Event Class;
@implementation Event

// Properties;
- (instancetype)initWithAttributes:(NSDictionary *)attributes
{
    self = [super init];
    if (self) {
        // User;
        self.user = [[User alloc] initWithAttributes:attributes[@"user"]];
        
        // Target;
        if ([attributes[@"action"] isEqualToString:@"posted"]) {
            self.target = [[Video alloc] initWithAttributes:attributes[@"target"]];
            self.action = 0;
        } else if ([attributes[@"action"] isEqualToString:@"favorited"]) {
            self.target = [[Video alloc] initWithAttributes:attributes[@"target"]];
            self.action = 1;
        } else if ([attributes[@"action"] isEqualToString:@"followed"]) {
            self.target = [[User alloc] initWithAttributes:attributes[@"target"]];
            self.action = 2;
        } else if ([attributes[@"action"] isEqualToString:@"joined"]) {
            self.action = 3;
        }
        
        // Created;
        self.createdAt = [attributes[@"created_at"] integerValue];
    }
    
    return self;
}

@end
