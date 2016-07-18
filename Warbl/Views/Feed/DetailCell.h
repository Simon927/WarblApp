//
//  DetailCell.h
//  Warbl
//
//  Created by Xin ZhangZhe on 4/3/14.
//  Copyright (c) 2014 sptmbr LLC. All rights reserved.
//
// --- Headers ---;
#import <UIKit/UIKit.h>

// --- Classes ---;
@class User;
@class Video;

// --- Defines ---;
// DetailCellDelegate Protocol;
@protocol DetailCellDelegate <NSObject>
@optional

- (void)didUser:(User *)user;
- (void)didRepost:(Video *)video;
- (void)didDelete:(Video *)video;
- (void)didFavorite:(Video *)video;
- (void)didShare:(Video *)video;

@end

// DetailCell Class;
@interface DetailCell : UITableViewCell
{
    IBOutlet UIButton *btnForUsername;
    IBOutlet UIButton *btnForPosts;
    IBOutlet UIButton *btnForFavorites;
    IBOutlet UIButton *btnForRepost;
    IBOutlet UIActivityIndicatorView *activityForRepost;
    IBOutlet UIButton *btnForFavorite;
    IBOutlet UIActivityIndicatorView *activityForFavorite;
}

// Properties;
@property (nonatomic, weak) id<DetailCellDelegate> delegate;
@property (nonatomic, weak) User *user;
@property (nonatomic, weak) Video *video;

@end
