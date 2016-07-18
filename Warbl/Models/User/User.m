//
//  User.m
//  Warbl
//
//  Created by Xin ZhangZhe on 4/3/14.
//  Copyright (c) 2014 sptmbr LLC. All rights reserved.
//
// --- Headers ---;
#import <FacebookSDK/FacebookSDK.h>

#import "User.h"
#import "APIClient.h"

// --- Defines ---;
// User Class;
@implementation User

// Functions;
#pragma mark - User
- (instancetype)initWithAttributes:(NSDictionary *)attributes
{
    self = [super init];
    if (self) {
        // Set;
        self.objectId = [attributes[@"id"] integerValue];
        self.userId = [attributes[@"userid"] integerValue];
        self.username = attributes[@"username"];
        self.name = attributes[@"name"];
        self.avatar = attributes[@"avatar"];
        self.posts = [attributes[@"posts"] integerValue];
        self.favorites = [attributes[@"favorites"] integerValue];
        self.follows = [attributes[@"follows"] integerValue];
        self.followed = [attributes[@"followed"] integerValue];
    }
    
    return self;
}

@end
