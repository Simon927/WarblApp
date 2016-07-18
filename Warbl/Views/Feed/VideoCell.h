//
//  VideoCell.h
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
// VideoCellDelegate Protocol;
@protocol VideoCellDelegate <NSObject>
@optional

- (void)didSelectVideo:(Video *)video;

@end

// VideoCell Class;
@interface VideoCell : UITableViewCell
{
    IBOutlet UIImageView *imgForThumbnail;
}

// Properties;
@property (nonatomic, weak) id<VideoCellDelegate> delegate;
@property (nonatomic, weak) Video *video;

@end
