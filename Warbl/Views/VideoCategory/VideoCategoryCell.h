//
//  VideoCategoryCell.h
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
// VideoCategoryCell Class;
@interface VideoCategoryCell : UITableViewCell

// Properties;
@property (nonatomic, weak) VideoCategory *videoCategory;

@end
