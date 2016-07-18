//
//  Friend.h
//  Warbl
//
//  Created by Xin ZhangZhe on 4/3/14.
//  Copyright (c) 2014 Xin ZhangZhe. All rights reserved.
//
// --- Headers ---;
#import <Foundation/Foundation.h>

// --- Classes ---;
@class User;

// --- Defines ---;
// Friend Class;
@interface Friend : NSObject

// Properties;
@property (nonatomic, retain) User *user;
@property (nonatomic, retain) User *followed;

@end
