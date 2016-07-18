//
//  AccountCell.h
//  Warbl
//
//  Created by Xin ZhangZhe on 4/3/14.
//  Copyright (c) 2014 sptmbr LLC. All rights reserved.
//
// --- Headers ---;
#import <UIKit/UIKit.h>

// --- Classes ---;
@class Account;

// --- Defines ---;
// AccountCellDelegate Protocol;
@protocol AccountCellDelegate <NSObject>
@optional

- (void)didReposts;
- (void)didFavorites;
- (void)didFollows;

@end

// AccountCell Class;
@interface AccountCell : UITableViewCell
{
    IBOutlet UIImageView *imgForAvatar;
    IBOutlet UILabel *lblForName;
    IBOutlet UIButton *btnForRepost;
    IBOutlet UIButton *btnForFavorite;
    IBOutlet UIButton *btnForFollow;
}

// Properties;
@property (nonatomic, weak) id <AccountCellDelegate> delegate;
@property (nonatomic, weak) Account *account;
@property (nonatomic, assign) NSInteger mode;

@end
