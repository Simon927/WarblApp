//
//  VideoCategory.h
//  Warbl
//
//  Created by Xin ZhangZhe on 4/3/14.
//  Copyright (c) 2014 sptmbr LLC. All rights reserved.
//
// --- Headers ---;
#import <Foundation/Foundation.h>

// --- Defines ---;
// VideoCategory Class;
@interface VideoCategory : NSObject

// Properties;
@property (nonatomic, strong) NSString *identifier;
@property (nonatomic, strong) NSString *title;

// Functions;
- (instancetype)initWithIdentifier:(NSString *)identifier title:(NSString *)title;

@end
