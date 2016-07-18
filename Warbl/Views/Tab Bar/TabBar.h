//
//  TabBar.h
//  Warbl
//
//  Created by Xin ZhangZhe on 4/3/14.
//  Copyright (c) 2014 sptmbr LLC. All rights reserved.
//
// --- Headers ---;
#import <UIKit/UIKit.h>

// --- Classes ---;
@class TabBar;

// --- Defines ---;
// TabBarDelegate Protocol;
@protocol TabBarDelegate<NSObject>
@optional

- (void)tabBar:(TabBar *)tabBar didSelectIndex:(NSInteger)index;

@end

// TabBar Class;
@interface TabBar : UIView
{
    IBOutlet UIButton *btnForFeed;
    IBOutlet UIButton *btnForFeatured;
    IBOutlet UIButton *btnForAccount;
    IBOutlet UIButton *btnForFollow;
    IBOutlet UIButton *btnForNotification;
}

// Properties;
@property (nonatomic, weak) id<TabBarDelegate> delegate;
@property (nonatomic, assign) NSUInteger selectedIndex;

@end
