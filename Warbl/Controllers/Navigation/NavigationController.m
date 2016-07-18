//
//  NavigationController.m
//  Warbl
//
//  Created by Xin ZhangZhe on 4/3/14.
//  Copyright (c) 2014 sptmbr LLC. All rights reserved.
//
// --- Headers ---;
#import "NavigationController.h"
#import "SignViewController.h"

#import "Account.h"

// --- Defines ---;
// NavigationController Class;
@interface NavigationController ()

// Properties;
@property (nonatomic, strong) UIViewController *mainController;

@end

@implementation NavigationController

// Functions;
#pragma mark - NavigationController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Notifications;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didUserLogin:) name:@"didUserLogin" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didUserLogout:) name:@"didUserLogout" object:nil];
    
    // Main Controller;
    self.mainController = [self.viewControllers firstObject];
    
    // Check;
    [self performSelector:@selector(didUserLogout:) withObject:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)dealloc
{
    // Notifications;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Notifications
- (void)didUserLogin:(NSNotification *)notification
{
    // Account;
    if ([[Account me] isAuthenticated]) {
        // Root Controller;
        self.viewControllers = @[self.mainController];
    }
}

- (void)didUserLogout:(NSNotification *)notification
{
    // Account;
    if (![[Account me] isAuthenticated]) {
        SignViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"SignViewController"];
        
        // Set;
        viewController.navigationItem.title = self.mainController.navigationItem.title;
        
        // Root Controller;
        self.viewControllers = @[viewController];
    }
}

@end
