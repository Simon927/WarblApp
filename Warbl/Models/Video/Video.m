//
//  Video.m
//  Warbl
//
//  Created by Xin ZhangZhe on 4/3/14.
//  Copyright (c) 2014 sptmbr LLC. All rights reserved.
//
// --- Headers ---;
#import "Video.h"

// --- Defines ---;
// Video Class;
@implementation Video

#pragma mark - Video
- (instancetype)initWithIdentifier:(NSString *)identifier title:(NSString *)title thumbnail:(NSString *)thumbnail
{
    self = [super init];
    if (self) {
        // Set;
        self.identifier = identifier;
        self.title = title;
        self.thumbnail = thumbnail;
    }
    
    return self;
}

- (instancetype)initWithAttributes:(NSDictionary *)attributes
{
    self = [super init];
    if (self) {
        // Set;
        [self setAttributes:attributes];
    }
    
    return self;
}

- (void)dealloc
{

}

- (void)setAttributes:(NSDictionary *)attributes
{
    self.objectId = [attributes[@"id"] integerValue];
    self.videoId = [attributes[@"videoid"] integerValue];
    self.identifier = attributes[@"identifier"];
    self.title = attributes[@"title"];
    self.thumbnail = attributes[@"thumbnail"];
    self.posted = [attributes[@"posted"] integerValue];
    self.posts = [attributes[@"posts"] integerValue];
    self.favorited = [attributes[@"favorited"] integerValue];
    self.favorites = [attributes[@"favorites"] integerValue];
}

@end
