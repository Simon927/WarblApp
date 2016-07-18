//
//  SearchViewController.h
//  Warbl
//
//  Created by Xin ZhangZhe on 4/3/14.
//  Copyright (c) 2014 sptmbr LLC. All rights reserved.
//
// --- Headers ---;
#import <UIKit/UIKit.h>

// --- Defines ---;
// FeaturedViewController Class;
@interface SearchViewController : UIViewController <UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate>
{
    IBOutlet UIView *viewForContent;
    IBOutlet UIView *viewForSearch;
    IBOutlet UITextField *txtForSearch;
    IBOutlet UITableView *tblForCategory;
}

@end
