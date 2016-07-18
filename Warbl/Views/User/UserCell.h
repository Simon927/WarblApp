//
//  UserCell.h
//  Warbl
//
//  Created by Xin ZhangZhe on 4/3/14.
//  Copyright (c) 2014 sptmbr LLC. All rights reserved.
//
// --- Headers ---;
#import <UIKit/UIKit.h>

// --- Classes ---;
@class User;

// --- Defines ---;
// UserCellDelegate Protocol;
@protocol UserCellDelegate <NSObject>
@optional

- (void)didReposts;
- (void)didFavorites;
- (void)didFollows;

@end

// UserCell Class;
@interface UserCell : UITableViewCell
{
    IBOutlet UIImageView *imgForAvatar;
    IBOutlet UILabel *lblForName;
    IBOutlet UIButton *btnForRepost;
    IBOutlet UIButton *btnForFavorite;
    IBOutlet UIButton *btnForFollow;
}

// Properties;
@property (nonatomic, weak) id <UserCellDelegate> delegate;
@property (nonatomic, weak) User *user;
@property (nonatomic, assign) NSInteger mode;

@end
