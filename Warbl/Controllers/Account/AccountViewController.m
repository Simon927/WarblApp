//
//  AccountViewController.m
//  Warbl
//
//  Created by Xin ZhangZhe on 4/3/14.
//  Copyright (c) 2014 sptmbr LLC. All rights reserved.
//
// --- Headers ---;
#import "AccountViewController.h"
#import "AccountCell.h"
#import "TitleCell.h"
#import "VideoCell.h"
#import "DetailCell.h"
#import "MoreCell.h"

#import "APIClient.h"
#import "Account.h"
#import "Video.h"

#import "XCDYouTubeVideoPlayerViewController.h"

#import "SDWebImageManager.h"

#import "ActivityItemProvider.h"

// --- Defines ---;
// AccountViewController Class;
@interface AccountViewController () <AccountCellDelegate, VideoCellDelegate, DetailCellDelegate>
{
    UIRefreshControl *refreshControl;
    
    NSInteger mode;
    NSInteger last;
    BOOL more;
}

// Properties;
@property (nonatomic, strong) NSMutableArray *posts;
@property (nonatomic, strong) Video *deletingVideo;

@end

@implementation AccountViewController

// Functions;
#pragma mark - AccountViewController
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
    [refreshControl addTarget:self action:@selector(loadPosts) forControlEvents:UIControlEventValueChanged];
    
    [self.tableView addSubview:refreshControl];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Notifications;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didUserLogin) name:@"didUserLogin" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didUpdateProfile) name:@"didUpdateProfile" object:nil];
    
    // Load;
    [self loadUser];
    [self loadPosts];
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
    if (more) {
        return [self.posts count] + 2;
    } else {
        return [self.posts count] + 1;
    }
    
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (!section) {
        return 1;
    } if (more && section == [self.posts count] + 1) {
        return 1;
    } else {
        return 3;
    }

    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!indexPath.section) {
        return 92.0f;
    } if (more && indexPath.section == [self.posts count] + 1) {
        return 44.0f;
    } else {
        Video *video = self.posts[indexPath.section - 1];
        
        switch (indexPath.row) {
            case 0:
                return [TitleCell heightForVideo:video];
                
            case 1:
                return 174.0f;
                
            case 2:
                return 50.0f;
                
            default:
                break;
        }
    }
    
    return 0.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!indexPath.section) {
        static NSString *AccountCellIdentifier = @"AccountCell";
        AccountCell *cell = [tableView dequeueReusableCellWithIdentifier:AccountCellIdentifier forIndexPath:indexPath];
        
        // Set;
        cell.delegate = self;
        cell.account = [Account me];
        cell.mode = mode;
        
        return cell;
    } if (more && indexPath.section == [self.posts count] + 1) {
        static NSString *MoreCellIdentifier = @"MoreCell";
        MoreCell *cell = [tableView dequeueReusableCellWithIdentifier:MoreCellIdentifier forIndexPath:indexPath];
        
        // Start;
        [cell startAnimating];
        
        // Load;
        [self loadMore];
        
        return cell;
    } else {
        Video *video = self.posts[indexPath.section - 1];
        
        switch (indexPath.row) {
            case 0:
            {
                static NSString *TitleCellIdentifier = @"TitleCell";
                TitleCell *cell = [tableView dequeueReusableCellWithIdentifier:TitleCellIdentifier forIndexPath:indexPath];
                
                // Set;
                cell.video = video;
                
                return cell;
            }
                
            case 1:
            {
                static NSString *VideoCellIdentifier = @"VideoCell";
                VideoCell *cell = [tableView dequeueReusableCellWithIdentifier:VideoCellIdentifier forIndexPath:indexPath];
                
                // Set;
                cell.delegate = self;
                cell.video = video;
                
                return cell;
            }
                
            case 2:
            {
                static NSString *DetailCellIdentifier = @"DetailCell";
                DetailCell *cell = [tableView dequeueReusableCellWithIdentifier:DetailCellIdentifier forIndexPath:indexPath];
                
                // Set;
                cell.delegate = self;
                cell.video = video;
                
                return cell;
            }
                
            default:
                break;
        }
    }
    
    return nil;
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        // Delete;
        [APIClient deleteVideo:self.deletingVideo completion:^(BOOL finished) {
            
        }];
        
        // Remove;
        [self.posts removeObject:self.deletingVideo];
        
        // Reload;
        [self.tableView reloadData];
    }
}

#pragma mark - Actions
- (void)didReposts
{
    // Set;
    mode = 0;
    more = NO;
    
    self.posts = nil;
    
    // Reload;
    [self.tableView reloadData];
    
    // Load;
    [self loadPosts];
}

- (void)didFavorites
{
    // Set;
    mode = 1;
    more = NO;
    
    self.posts = nil;
    
    // Reload;
    [self.tableView reloadData];
    
    // Load;
    [self loadPosts];
}

- (void)didFollows
{
    
}

- (void)didSelectVideo:(Video *)video
{
    XCDYouTubeVideoPlayerViewController *viewController = [[XCDYouTubeVideoPlayerViewController alloc] initWithVideoIdentifier:video.identifier];
    
    // Present;
	[self presentMoviePlayerViewControllerAnimated:viewController];
}

- (void)didRepost:(Video *)video
{
    // Account;
    if (![[Account me] isAuthenticated]) {
        return;
    }
    
    // Repost;
    if (!video.posted) {
        [APIClient repostVideo:video completion:^(BOOL finished) {
            // Reload;
            [self.tableView reloadData];
        }];
    } else {
        [APIClient deleteVideo:video completion:^(BOOL finished) {
            if (mode == 0) {
                // Remove;
                [self.posts removeObject:video];
            }
            
            // Reload;
            [self.tableView reloadData];
        }];
    }
}

- (void)didDelete:(Video *)video
{
    // Account;
    if (![[Account me] isAuthenticated]) {
        return;
    }
    
    // Deleting;
    self.deletingVideo = video;
    
    // Show;
    [[[UIAlertView alloc] initWithTitle:@"Are you sure?" message:@"If you delete this video, it will be deleted. You can find it again anytime." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Delete", nil] show];
}

- (void)didFavorite:(Video *)video
{
    // Account;
    if (![[Account me] isAuthenticated]) {
        return;
    }
    
    // Favorite;
    if (!video.favorited) {
        [APIClient favoriteVideo:video completion:^(BOOL finished) {
            // Reload;
            [self.tableView reloadData];
        }];
    } else {
        [APIClient unfavoriteVideo:video completion:^(BOOL finished) {
            // Reload;
            [self.tableView reloadData];
        }];
    }
}

- (void)didShare:(Video *)video
{
    // Image ;
    [[SDWebImageManager sharedManager] downloadWithURL:[NSURL URLWithString:video.thumbnail] options:SDWebImageRefreshCached progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished) {
        if (finished) {
            ActivityItemProvider *provider = [[ActivityItemProvider alloc] initWithPlaceholderItem:video.title];
            UIImage *thumbnail = image;
            NSArray *items = [NSArray arrayWithObjects:provider, thumbnail, nil];
            
            UIActivityViewController *viewController = [[UIActivityViewController alloc] initWithActivityItems:items applicationActivities:nil];
            
            // Set;
//          viewController.excludedActivityTypes = @[UIActivityTypePostToWeibo, UIActivityTypeAssignToContact, UIActivityTypePrint, UIActivityTypeCopyToPasteboard, UIActivityTypeSaveToCameraRoll];
            viewController.completionHandler = ^(NSString *activityType, BOOL completed) {
                
            };
            
            // Present;
            [self presentViewController:viewController animated:YES completion:^{
                
            }];
        }
    }];
}

#pragma mark - Notifications
- (void)didUserLogin
{
    // Load;
    [self loadUser];
    [self loadPosts];
}

- (void)didUpdateProfile
{
    // Load;
    [self loadUser];
    [self loadPosts];
}

#pragma mark - Load
- (void)loadUser
{
    Account *me = [Account me];
    
    // Title;
    self.navigationItem.title = me.username;
}

#pragma mark - Load
- (void)loadPosts
{
    // Set;
    last = 0;
    more = NO;
    
    void (^completion)(NSArray *posts) = ^(NSArray *posts) {
        // Set;
        Video *video = [posts lastObject];
        
        last = video.objectId;
        more = [posts count] == DEFAULT_COUNT;
        
        // Animation;
        if ([refreshControl isRefreshing]) {
            [refreshControl endRefreshing];
        }
        
        // Posts;
        self.posts = [NSMutableArray arrayWithArray:posts];
        
        // Reload;
        [self.tableView reloadData];
    };
    
    // Get;
    switch (mode) {
        case 0:     // Reposts;
            [APIClient getReposts:last count:DEFAULT_COUNT completion:completion];
            break;
            
        case 1:     // Favorites;
            [APIClient getFavorites:last count:DEFAULT_COUNT completion:completion];
            break;
            
        default:
            break;
    }
}

- (void)loadMore
{
    void (^completion)(NSArray *posts) = ^(NSArray *posts) {
        // Set;
        Video *video = [posts lastObject];
        
        last = video.objectId;
        more = [posts count] == DEFAULT_COUNT;
        
        // Posts;
        [self.posts addObjectsFromArray:posts];
        
        // Reload;
        [self.tableView reloadData];
    };
    
    // Get;
    switch (mode) {
        case 0:     // Reposts;
            [APIClient getReposts:last count:DEFAULT_COUNT completion:completion];
            break;
            
        case 1:     // Favorites;
            [APIClient getFavorites:last count:DEFAULT_COUNT completion:completion];
            break;
            
        default:
            break;
    }
}

@end
