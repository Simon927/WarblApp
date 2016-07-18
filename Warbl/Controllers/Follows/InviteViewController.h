//
//  InviteViewController.h
//  Warbl
//
//  Created by Xin ZhangZhe on 4/3/14.
//  Copyright (c) 2014 sptmbr LLC. All rights reserved.
//
// --- Headers ---;
#import <UIKit/UIKit.h>

// --- Classes ---;
@class FUIButton;

// --- Defines ---;
// InviteViewController Class;
@interface InviteViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
{
    IBOutlet UIBarButtonItem *itemForSkip;
    IBOutlet UITextField *txtForSearch;
    IBOutlet UIView *viewForFacebook;
    IBOutlet FUIButton *btnFacebook;
    IBOutlet UITableView *tblForFollow;
}

// Properties;
@property (nonatomic, assign) BOOL skipped;

@end
