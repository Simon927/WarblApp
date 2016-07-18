//
//  FollowNavigationController.m
//  Warbl
//
//  Created by Xin ZhangZhe on 4/3/14.
//  Copyright (c) 2014 sptmbr LLC. All rights reserved.
//
// --- Headers ---;
#import "FollowNavigationController.h"
#import "SignViewController.h"
#import "InviteViewController.h"

#import "Account.h"

// --- Defines ---;
// FollowNavigationController Class;
@interface FollowNavigationController ()

// Properties;
@property (nonatomic, strong) UIViewController *mainController;

@end

@implementation FollowNavigationController

// Functions;
#pragma mark - FollowNavigationController
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

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if ([Account me].follows) {
        UIViewController *viewController = [self.viewControllers firstObject];
        
        if (viewController != self.mainController) {
            // Root Controller;
            self.viewControllers = @[self.mainController];
        }
    }
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
        if (![Account me].follows) {
            InviteViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"InviteViewController"];
            
            // Set;
            viewController.navigationItem.title = self.mainController.navigationItem.title;
            
            // Root Controller;
            self.viewControllers = @[viewController];
        } else {
            // Root Controller;
            self.viewControllers = @[self.mainController];
        }
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
