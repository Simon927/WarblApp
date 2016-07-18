//
//  NotificationCell.h
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
@class Event;
@class TTTAttributedLabel;

// --- Defines ---;
// NotificationCellDelegate Protocol;
@protocol NotificationCellDelegate <NSObject>
@optional

- (void)didUser:(User *)user;

@end

// NotificationCell Class;
@interface NotificationCell : UITableViewCell
{
    IBOutlet UIButton *btnForAvatar;
    IBOutlet TTTAttributedLabel *lblForNotification;
}

// Proerpties;
@property (nonatomic, weak) id <NotificationCellDelegate> delegate;
@property (nonatomic, weak) Event *notification;

// Functions;
+ (CGFloat)heightForVideo:(Event *)event;

@end
