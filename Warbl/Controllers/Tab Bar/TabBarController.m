//
//  TabBarController.m
//  Warbl
//
//  Created by Xin ZhangZhe on 4/3/14.
//  Copyright (c) 2014 sptmbr LLC. All rights reserved.
//
// --- Headers ---;
#import "TabBarController.h"
#import "TabBar.h"

#import "Account.h"

// --- Defines ---;
// TabBarController Class;
@interface TabBarController () <TabBarDelegate>

// Properties;
@property (nonatomic, strong) TabBar *customizedTabBar;

@end

@implementation TabBarController

// Functions;
#pragma mark - TabBarController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void) loadView
{
    [super loadView];
    
    // Tab Bar;
    self.customizedTabBar = [[[NSBundle mainBundle] loadNibNamed:@"TabBar" owner:nil options:nil] objectAtIndex:0];
    self.customizedTabBar.delegate = self;
    
    [self.tabBar addSubview:self.customizedTabBar];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Account;
    if (![[Account me] isAuthenticated]) {
        [self.customizedTabBar setSelectedIndex:1];
    } else {
        [self.customizedTabBar setSelectedIndex:0];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)dealloc
{
    [self.customizedTabBar removeFromSuperview];
}

#pragma mark - TabBarDelegate
- (void)tabBar:(TabBar *)tabBar didSelectIndex:(NSInteger)index
{
    if (index != self.selectedIndex) {
        self.selectedIndex = index;
    } else if ([self.selectedViewController isKindOfClass:[UINavigationController class]]) {
        [(UINavigationController*)self.selectedViewController popToRootViewControllerAnimated:YES];
    }
}

@end
