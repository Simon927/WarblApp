//
//  Account.h
//  Warbl
//
//  Created by Xin ZhangZhe on 4/3/14.
//  Copyright (c) 2014 sptmbr LLC. All rights reserved.
//
// --- Headers ---;
#import <Foundation/Foundation.h>

// --- Classes ---;
@class User;
@class Video;

// --- Defines ---;
// UserError Values;
typedef enum {
    AccountMessageSuccessed,
    AccountMessageInvalidConnection,
    AccountMessageInvalidUsername,
    AccountMessageInvalidEmail,
    AccountMessageInvaildUserInfo
} AccountMessage;

// Account Class;
@interface Account : NSObject

// Properties;
@property (nonatomic, strong) NSString *objectId;
@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *avatar;
@property (nonatomic, assign) NSInteger quality;
@property (nonatomic, assign) NSInteger posts;
@property (nonatomic, assign) NSInteger favorites;
@property (nonatomic, assign) NSInteger follows;
@property (nonatomic, assign) NSInteger createAt;

// Functions;
+ (instancetype)me;

- (instancetype)initWithAttributes:(NSDictionary *)attributes;
- (BOOL)isAuthenticated;
- (void)logout;

- (void)setAttributes:(NSDictionary *)attributes;

@end
