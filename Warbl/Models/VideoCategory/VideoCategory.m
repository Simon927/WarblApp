//
//  VideoCategory.m
//  Warbl
//
//  Created by Xin ZhangZhe on 4/3/14.
//  Copyright (c) 2014 sptmbr LLC. All rights reserved.
//
// --- Headers ---;
#import "VideoCategory.h"

// --- Defines ---;
// VideoCategory Class;
@implementation VideoCategory

// Functions;
#pragma mark - VideoCategory
- (instancetype)initWithIdentifier:(NSString *)identifier title:(NSString *)title
{
    self = [super init];
    if (self) {
        // Set;
        self.identifier = identifier;
        self.title = title;
    }
    
    return self;
}

- (void)dealloc
{

}

@end
