//
//  YouTubeVideo.h
//  Warbl
//
//  Created by Xin ZhangZhe on 4/3/14.
//  Copyright (c) 2014 Xin ZhangZhe. All rights reserved.
//
// --- Headers ---;
#import <Foundation/Foundation.h>

// --- Classes ---;
@class User;
@class YouTubeCategory;

// --- Defines ---;
// YouTubeVideo Class;
@interface YouTubeVideo : NSObject

// Properties;
@property (nonatomic, retain) NSString *objectId;
@property (nonatomic, retain) NSString *identifier;
@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSString *thumbnail;
@property (nonatomic)         NSInteger posted;
@property (nonatomic)         NSInteger posts;
@property (nonatomic)         NSInteger favorited;
@property (nonatomic)         NSInteger favorites;

// Funtions;
+ (void)feed:(User *)user completion:(void (^)(BOOL finished))completion;
+ (void)featuredWithCompletion:(void (^)(BOOL finished))completion;
+ (void)search:(NSString *)text inCategory:(YouTubeCategory *)category pageToken:(NSString *)pageToken completion:(void (^)(NSArray *videos, NSString *nextPageToken))completion;
+ (void)videos:(User *)user completion:(void (^)(BOOL finished))completion;

- (void)postRepostWithCompletion:(void (^)(BOOL finished))completion;
- (void)postDeleteWithCompletion:(void (^)(BOOL finished))completion;
- (void)posts:(void (^)(BOOL finished))completion;

- (void)favoriteRepostWithCompletion:(void (^)(BOOL finished))completion;
- (void)favoriteAddWithCompletion:(void (^)(BOOL finished))completion;
- (void)favoritesWithCompletion:(void (^)(BOOL finished))completion;

@end
