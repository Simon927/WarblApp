//
//  UserViewController.h
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
// UserViewController Class;
@interface UserViewController : UITableViewController <UIAlertViewDelegate>
{
    IBOutlet UIBarButtonItem *itemForFollow;
}

// Properties;
@property (nonatomic, strong) User *user;

@end
