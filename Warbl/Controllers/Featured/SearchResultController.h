//
//  SearchResultController.h
//  Warbl
//
//  Created by Xin ZhangZhe on 4/3/14.
//  Copyright (c) 2014 sptmbr LLC. All rights reserved.
//
// --- Headers ---;
#import <UIKit/UIKit.h>

// --- Classes ---;
@class VideoCategory;

// --- Defines ---;
// SearchResultController Class;
@interface SearchResultController : UITableViewController

// Properties;
@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) VideoCategory *videoCategory;

@end
