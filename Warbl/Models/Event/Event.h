//
//  Event.h
//  Warbl
//
//  Created by Xin ZhangZhe on 4/3/14.
//  Copyright (c) 2014 Xin ZhangZhe. All rights reserved.
//
// --- Headers ---;
#import <Foundation/Foundation.h>

// --- Classes ---;
@class User;
@class Video;

// --- Defines ---;
// Event Class;
@interface Event : NSObject

// Properties;
@property (nonatomic, strong) User *user;
@property (nonatomic, strong) id target;
@property (nonatomic, assign) NSInteger action;
@property (nonatomic, assign) NSInteger createdAt;

// Functions;
- (instancetype)initWithAttributes:(NSDictionary *)attributes;

@end
