//
//  FollowCell.h
//  Warbl
//
//  Created by Xin ZhangZhe on 4/3/14.
//  Copyright (c) 2014 sptmbr LLC. All rights reserved.
//
// --- Headers ---;
#import <UIKit/UIKit.h>

// --- Classes ---;
@class User;
@class TTTAttributedLabel;

// --- Defines ---;
// FollowCellDelegate Protocol;
@protocol FollowCellDelegate <NSObject>
@optional

- (void)didUser:(User *)user;
- (void)didFollow:(User *)user;

@end

// FollowCell Class;
@interface FollowCell : UITableViewCell
{
    IBOutlet UIButton *btnForAvatar;
    IBOutlet TTTAttributedLabel *lblForUsername;
    IBOutlet UILabel *lblForFullname;
    IBOutlet UIButton *btnForFollow;
    IBOutlet UIActivityIndicatorView *activityForFollow;
}

// Properties;
@property (nonatomic, weak) id <FollowCellDelegate> delegate;
@property (nonatomic, weak) User *user;

@end
