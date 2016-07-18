//
//  VideoCategoryCell.m
//  Warbl
//
//  Created by Xin ZhangZhe on 4/3/14.
//  Copyright (c) 2014 sptmbr LLC. All rights reserved.
//
// --- Headers ---;
#import "VideoCategoryCell.h"
#import "VideoCategory.h"

// --- Defines ---;
// VideoCategoryCell Class;
@implementation VideoCategoryCell

// Functions;
#pragma mark - VideoCategoryCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

- (void)setVideoCategory:(VideoCategory *)videoCategory
{
    // Set;
    _videoCategory = videoCategory;
    
    // UI;
    self.textLabel.text = self.videoCategory.title;
}

@end
