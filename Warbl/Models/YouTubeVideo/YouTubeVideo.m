//
//  YouTubeVideo.m
//  Warbl
//
//  Created by Xin ZhangZhe on 4/3/14.
//  Copyright (c) 2014 Xin ZhangZhe. All rights reserved.
//
// --- Headers ---;
#import "YouTubeVideo.h"

// --- Defines ---;
// YouTubeVideo Class;
@implementation YouTubeVideo

#pragma mark - Feed
+ (void)feed:(User *)user completion:(void (^)(BOOL finished))completion
{
    
}

#pragma mark - Featured
+ (void)featuredWithCompletion:(void (^)(BOOL finished))completion
{
    
}

#pragma mark - YouTube
+ (void)search:(NSString *)text inCategory:(YouTubeCategory *)category pageToken:(NSString *)pageToken completion:(void (^)(NSArray *videos, NSString *nextPageToken))completion
{
    
}

#pragma mark - User
+ (void)videos:(User *)user completion:(void (^)(BOOL finished))completion
{
    
}

#pragma mark - Post
- (void)postRepostWithCompletion:(void (^)(BOOL finished))completion
{
    
}

- (void)postDeleteWithCompletion:(void (^)(BOOL finished))completion
{
    
}

- (void)posts:(void (^)(BOOL finished))completion
{
    
}

#pragma mark - Favorite
- (void)favoriteRepostWithCompletion:(void (^)(BOOL finished))completion
{
    
}

- (void)favoriteAddWithCompletion:(void (^)(BOOL finished))completion
{
    
}

- (void)favoritesWithCompletion:(void (^)(BOOL finished))completion
{
    
}

@end
