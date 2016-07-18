//
//  Favorite.h
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
// Favorite Class;
@interface Favorite : NSObject

// Properties;
@property (nonatomic, retain) User *user;
@property (nonatomic, retain) Video *video;

@end
