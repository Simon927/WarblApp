//
//  NotificationViewController.m
//  Warbl
//
//  Created by Xin ZhangZhe on 4/3/14.
//  Copyright (c) 2014 sptmbr LLC. All rights reserved.
//
// --- Headers ---;
#import "NotificationViewController.h"
#import "NotificationCell.h"
#import "MoreCell.h"

#import "UserViewController.h"

#import "APIClient.h"
#import "User.h"
#import "Video.h"
#import "Event.h"

// --- Defines ---;
// NotificationViewController Class;
@interface NotificationViewController () <NotificationCellDelegate>
{
    UIRefreshControl *refreshControl;

    NSInteger last;
    BOOL more;
}

// Properties;
@property (nonatomic, strong) NSMutableArray *notifications;

@end

@implementation NotificationViewController

// Functions;
#pragma mark - NotificationViewController
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        
    }
    return self;
}

- (void)loadView
{
    [super loadView];
    
    // Refresh Control;
    refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(loadNotifications) forControlEvents:UIControlEventValueChanged];
    
    [self.tableView addSubview:refreshControl];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Notifications;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didUserLogin) name:@"didUserLogin" object:nil];
    
    // Load;
    [self loadNotifications];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)dealloc
{
    // Refresh Control;    
    [refreshControl removeFromSuperview];
    
    // Notifications;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (more) {
        return [self.notifications count] + 1;
    } else {
        return [self.notifications count];
    }
    
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (more && indexPath.row == [self.notifications count]) {
        return 44.0f;
    } else {
        return [NotificationCell heightForVideo:self.notifications[indexPath.row]];
    }
    
    return 0.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (more && indexPath.row == [self.notifications count]) {
        static NSString *MoreCellIdentifier = @"MoreCell";
        MoreCell *cell = [tableView dequeueReusableCellWithIdentifier:MoreCellIdentifier forIndexPath:indexPath];
        
        // Start;
        [cell startAnimating];
        
        // Load;
        [self loadMore];
        
        return cell;
    } else {
        static NSString *NotificationellIdentifier = @"NotificationCell";
        NotificationCell *cell = [tableView dequeueReusableCellWithIdentifier:NotificationellIdentifier forIndexPath:indexPath];
        
        // Set;
        cell.delegate = self;
        cell.notification = self.notifications[indexPath.row];
        
        return cell;
    }
    
    return nil;
}

#pragma mark - NotificationCellDelegate
- (void)didUser:(User *)user
{
    UserViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"UserViewController"];
    
    // Set;
    viewController.user = user;
    
    // Push;
    [self.navigationController pushViewController:viewController animated:YES];
}

#pragma mark - Notifications
- (void)didUserLogin
{
    if ([[Account me] isAuthenticated]) {
        // Offset;
        [self.tableView setContentOffset:CGPointZero];
        
        // Load;
        [self loadNotifications];
    }
}

#pragma mark - Load
- (void)loadNotifications
{
    // Set;
    last = 0;
    more = NO;
    
    // Animation;
    [refreshControl beginRefreshing];
    
    // Get;
    [APIClient getNotifications:last count:DEFAULT_COUNT completion:^(NSArray *notifications) {
        // Set;
        Event *event = [notifications lastObject];
        
        last = event.createdAt;
        more = [notifications count] == DEFAULT_COUNT;
        
        // Animation;
        [refreshControl endRefreshing];
        
        // Posts;
        self.notifications = [NSMutableArray arrayWithArray:notifications];
        
        // Reload;
        [self.tableView reloadData];
    }];
}

- (void)loadMore
{
    [APIClient getNotifications:last count:DEFAULT_COUNT completion:^(NSArray *notifications) {
        // Set;
        Event *event = [notifications lastObject];
        
        last = event.createdAt;
        more = [notifications count] == DEFAULT_COUNT;
        
        // Posts;
        [self.notifications addObjectsFromArray:notifications];
        
        // Reload;
        [self.tableView reloadData];
    }];
}

@end
