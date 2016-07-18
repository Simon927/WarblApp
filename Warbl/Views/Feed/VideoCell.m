//
//  VideoCell.m
//  Warbl
//
//  Created by Xin ZhangZhe on 4/3/14.
//  Copyright (c) 2014 sptmbr LLC. All rights reserved.
//
// --- Headers ---;
#import "VideoCell.h"
#import "Video.h"

#import "UIImageView+WebCache.h"

// --- Defines ---;
// VideoCell Class;
@implementation VideoCell

// Functions;
#pragma mark - VideoCell
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

- (void)setVideo:(Video *)video
{
    // Set;
    _video = video;
    
    // UI;
    [imgForThumbnail setImageWithURL:[NSURL URLWithString:self.video.thumbnail] placeholderImage:nil];
}

#pragma mark - Events
- (IBAction)onBtnPlay:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(didSelectVideo:)]) {
        [self.delegate performSelector:@selector(didSelectVideo:) withObject:self.video];
    }
}

@end
