//
//  Video.h
//  Warbl
//
//  Created by Xin ZhangZhe on 4/3/14.
//  Copyright (c) 2014 sptmbr LLC. All rights reserved.
//
// --- Headers ---;
#import <Foundation/Foundation.h>

// --- Defines ---;
// Video Class;
@interface Video : NSObject

// Properties;
@property (nonatomic, assign) NSInteger objectId;
@property (nonatomic, assign) NSInteger videoId;
@property (nonatomic, strong) NSString *identifier;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *thumbnail;
@property (nonatomic)         NSInteger posted;
@property (nonatomic)         NSInteger posts;
@property (nonatomic)         NSInteger favorited;
@property (nonatomic)         NSInteger favorites;
@property (nonatomic, strong) NSDate *createdAt;

// Funtions;
- (instancetype)initWithIdentifier:(NSString *)identifier title:(NSString *)title thumbnail:(NSString *)thumbnail;
- (instancetype)initWithAttributes:(NSDictionary *)attributes;
- (void)setAttributes:(NSDictionary *)attributes;

@end
