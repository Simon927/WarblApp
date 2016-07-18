//
//  TitleCell.h
//  Warbl
//
//  Created by Xin ZhangZhe on 4/3/14.
//  Copyright (c) 2014 sptmbr LLC. All rights reserved.
//
// --- Headers ---;
#import <UIKit/UIKit.h>

// --- Classes ---;
@class Video;

// --- Defines ---;
// TitleCell Class;
@interface TitleCell : UITableViewCell

// Properties;
@property (nonatomic, weak) Video *video;

// Functions;
+ (CGFloat)heightForVideo:(Video *)video;

@end
