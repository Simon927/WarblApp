//
//  FollowViewController.m
//  Warbl
//
//  Created by Xin ZhangZhe on 4/3/14.
//  Copyright (c) 2014 sptmbr LLC. All rights reserved.
//
// --- Headers ---;
#import "FollowViewController.h"
#import "FollowCell.h"
#import "MoreCell.h"

#import "UserViewController.h"

#import "APIClient.h"
#import "User.h"

// --- Defines ---;
// FollowViewController Class;
@interface FollowViewController () <FollowCellDelegate>
{
    UIRefreshControl *refreshControl;
    
    NSInteger last;
    BOOL more;
}

// Properties;
@property (nonatomic, strong) NSMutableArray *follows;

@end

@implementation FollowViewController

// Functions;
#pragma mark - FollowViewController
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
    [refreshControl addTarget:self action:@selector(loadFollows) forControlEvents:UIControlEventValueChanged];
    
    [self.tableView addSubview:refreshControl];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Notifications;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didUserLogin) name:@"didUserLogin" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didFollowUser:) name:@"didFollowUser" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didUnfollowUser:) name:@"didUnfollowUser" object:nil];
    
    // Load;
    [self loadFollows];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    // Reload;
    [self.tableView reloadData];
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
        return [self.follows count] + 1;
    }
    
    return [self.follows count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (more && indexPath.row == [self.follows count]) {
        static NSString *MoreCellIdentifier = @"MoreCell";
        MoreCell *cell = [tableView dequeueReusableCellWithIdentifier:MoreCellIdentifier forIndexPath:indexPath];
        
        // Start;
        [cell startAnimating];
        
        // Load;
        [self loadMore];
        
        return cell;
    } else {
        static NSString *FollowCellIdentifier = @"FollowCell";
        FollowCell *cell = [tableView dequeueReusableCellWithIdentifier:FollowCellIdentifier forIndexPath:indexPath];
        
        // Set;
        cell.delegate = self;
        cell.user = self.follows[indexPath.row];
        
        return cell;
    }
    
    return nil;
}

#pragma mark - FollowCellDelegate
- (void)didUser:(User *)user
{
    UserViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"UserViewController"];
    
    // Set;
    viewController.user = user;
    
    // Push;
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)didFollow:(User *)user
{
    // Follow;
    if (!user.followed) {
        [APIClient followUser:user completion:^(BOOL finished) {
            // Reload;
            [self.tableView reloadData];
            
            // Notification;
            [[NSNotificationCenter defaultCenter] postNotificationName:@"didFollow" object:user];
        }];
    } else {
        [APIClient unfollowUser:user completion:^(BOOL finished) {
            // Reload;
            [self.tableView reloadData];
        }];
    }
}

#pragma mark - Notifications
- (void)didUserLogin
{
    if ([[Account me] isAuthenticated]) {
        // Offset;
        [self.tableView setContentOffset:CGPointZero];
        
        // Load;
        [self loadFollows];
    }
}

- (void)didFollowUser:(NSNotification *)notification
{
    User *user = [notification object];
    
    if (!self.follows) {
        self.follows = [NSMutableArray array];
    }
    
    // Add;
    [self.follows insertObject:user atIndex:0];
}

- (void)didUnfollowUser:(NSNotification *)notification
{
    User *user = [notification object];
    
    // Add;
    for (User *follow in self.follows) {
        if (follow.userId == user.userId) {
            [self.follows removeObject:follow];
            break;
        }
    }
}

#pragma mark - Load
- (void)loadFollows
{
    // Set;
    last = 0;
    more = NO;
    
    // Animation;
    [refreshControl beginRefreshing];
    
    // Get;
    [APIClient getFollows:last count:DEFAULT_COUNT completion:^(NSArray *follows) {
        // Set;
        User *follow = [follows lastObject];
        
        last = follow.objectId;
        more = [follows count] == DEFAULT_COUNT;
        
        // Animation;
        [refreshControl endRefreshing];
        
        // Follows;
        self.follows = [NSMutableArray arrayWithArray:follows];
        
        // Reload;
        [self.tableView reloadData];
    }];
}

- (void)loadMore
{
    // Get;
    [APIClient getFollows:last count:DEFAULT_COUNT completion:^(NSArray *follows) {
        // Set;
        User *follow = [follows lastObject];
        
        last = follow.objectId;
        more = [follows count] == DEFAULT_COUNT;

        // Follows;
        [self.follows addObjectsFromArray:follows];
        
        // Reload;
        [self.tableView reloadData];
    }];
}

@end
