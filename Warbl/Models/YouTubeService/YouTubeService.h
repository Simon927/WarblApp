//
//  YouTubeService.h
//  Warbl
//
//  Created by Xin ZhangZhe on 4/3/14.
//  Copyright (c) 2014 sptmbr LLC. All rights reserved.
//
// --- Headers ---;
#import <Foundation/Foundation.h>

#import "GTLYouTube.h"

// --- Classes ---;
@class VideoCategory;

// --- Defines ---;
// YouTubeService Class;
@interface YouTubeService : NSObject

// Functions;
+ (void)youTubeVideoCategoriesWithCompletion:(void (^)(NSArray *videoCategories))completion;
+ (void)youTubeVideoForText:(NSString *)text inVideoCategory:(VideoCategory *)videoCategory pageToken:(NSString *)pageToken completion:(void (^)(NSArray *posts, NSString *nextPageToken))completion;

@end
