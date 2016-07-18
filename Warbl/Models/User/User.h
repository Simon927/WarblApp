//
//  User.h
//  Warbl
//
//  Created by Xin ZhangZhe on 4/3/14.
//  Copyright (c) 2014 sptmbr LLC. All rights reserved.
//
// --- Headers ---;
#import <Foundation/Foundation.h>

// --- Defines ---;
// User Class;
@interface User : NSObject

// Properties;
@property (nonatomic, assign) NSInteger objectId;
@property (nonatomic, assign) NSInteger userId;
@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *avatar;
@property (nonatomic)         NSInteger posts;
@property (nonatomic)         NSInteger favorites;
@property (nonatomic)         NSInteger follows;
@property (nonatomic)         NSInteger followed;

// Functions;
- (instancetype)initWithAttributes:(NSDictionary *)attributes;

@end
