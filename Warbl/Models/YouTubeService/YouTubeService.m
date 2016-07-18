//
//  YouTubeService.m
//  Warbl
//
//  Created by Xin ZhangZhe on 4/3/14.
//  Copyright (c) 2014 sptmbr LLC. All rights reserved.
//
// --- Headers ---;
#import "YouTubeService.h"
#import "VideoCategory.h"
#import "Video.h"

// --- Defines ---;
// YouTube;
static NSString * const kYouTubeAPIKey = @"AIzaSyDUeGbUn9sj4jHwLBFNp7sJ_FYu3uD4iAA";

// YouTubeService Class;
@interface YouTubeService ()

@end

@implementation YouTubeService

// Functions;
#pragma mark - Shared Functions
+ (GTLServiceYouTube *)youTubeService
{
    static GTLServiceYouTube *_youTubeService;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        _youTubeService = [[GTLServiceYouTube alloc] init];
        
        // Set;
        _youTubeService.APIKey = kYouTubeAPIKey;
        _youTubeService.retryEnabled = YES;
    });
    
    return _youTubeService;
}

+ (void)youTubeVideoCategoriesWithCompletion:(void (^)(NSArray *videoCategories))completion
{
    GTLQueryYouTube *query = [GTLQueryYouTube queryForVideoCategoriesListWithPart:@"snippet"];
    
    // Set;
    query.regionCode = @"US";
    
    // Execute;
    [[self youTubeService] executeQuery:query completionHandler:^(GTLServiceTicket *ticket, id object, NSError *error) {
        NSMutableArray *videoCategories = [NSMutableArray array];
        
        if (!error) {
            GTLYouTubeVideoCategoryListResponse *response = object;
            
            for (GTLYouTubeVideoCategory *item in response.items) {
                if ([item.snippet.assignable boolValue]) {
                    VideoCategory *videoCategory = [[VideoCategory alloc] initWithIdentifier:item.identifier title:item.snippet.title];
                    
                    // Add;
                    [videoCategories addObject:videoCategory];
                }
            }
        }
        
        if (completion) {
            completion(videoCategories);
        }
    }];
}

+ (void)youTubeVideoForText:(NSString *)text inVideoCategory:(VideoCategory *)videoCategory pageToken:(NSString *)pageToken completion:(void (^)(NSArray *posts, NSString *nextPageToken))completion
{
    GTLQueryYouTube *query = [GTLQueryYouTube queryForSearchListWithPart:@"id,snippet"];
    
    // Set;
    query.maxResults = DEFAULT_COUNT;
    query.q = text;
    query.type = @"video";
    query.videoCategoryId = videoCategory.identifier;
    query.pageToken = pageToken;
    
    // Execute;
    [[self youTubeService] executeQuery:query completionHandler:^(GTLServiceTicket *ticket, id object, NSError *error) {
        NSMutableArray *posts = [NSMutableArray array];
        NSString *nextPageToken = nil;
        
        if (!error) {
            GTLYouTubeSearchListResponse *response = object;
            
            // Items;
            for (GTLYouTubeSearchResult *item in response.items) {
                Video *video = [[Video alloc] initWithIdentifier:item.identifier.JSON[@"videoId"] title:item.snippet.title thumbnail:item.snippet.thumbnails.high.url];
                
                // Add;
                [posts addObject:video];
            }
            
            // Next Page;
            nextPageToken = response.nextPageToken;
        }
        
        if (completion) {
            completion(posts, nextPageToken);
        }
    }];
}

@end
