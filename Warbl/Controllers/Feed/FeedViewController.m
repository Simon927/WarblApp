//
//  FeedViewController.h
//  Warbl
//
//  Created by Xin ZhangZhe on 4/3/14.
//  Copyright (c) 2014 sptmbr LLC. All rights reserved.
//
// --- Headers ---;
#import "FeedViewController.h"
#import "TitleCell.h"
#import "VideoCell.h"
#import "DetailCell.h"
#import "MoreCell.h"

#import "UserViewController.h"

#import "APIClient.h"
#import "User.h"
#import "Video.h"
#import "Event.h"

#import "XCDYouTubeVideoPlayerViewController.h"

#import "SDWebImageManager.h"

#import "ActivityItemProvider.h"

// --- Defines ---;
// FeedViewController Class;
@interface FeedViewController () <VideoCellDelegate, DetailCellDelegate>
{
    UIRefreshControl *refreshControl;
    
    NSInteger last;
    BOOL more;
}

// Properties;
@property (nonatomic, strong) NSMutableArray *posts;

@end

@implementation FeedViewController

// Functions;
#pragma mark - FeedViewController
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
    
    // Load;
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
        return [self.posts count] + 1;
    }
    
    return [self.posts count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (more && section == [self.posts count]) {
        return 1;
    }
    
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (more && indexPath.section == [self.posts count]) {
        return 44.0f;
    } else {
        Event *event = self.posts[indexPath.section];
        Video *video = event.target;
        
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
    if (more && indexPath.section == [self.posts count]) {
        static NSString *MoreCellIdentifier = @"MoreCell";
        MoreCell *cell = [tableView dequeueReusableCellWithIdentifier:MoreCellIdentifier forIndexPath:indexPath];
        
        // Start;
        [cell startAnimating];
        
        // Load;
        [self loadMore];
        
        return cell;
    } else {
        Event *event = self.posts[indexPath.section];
        User *user = event.user;
        Video *video = event.target;
        
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
                cell.user = user;
                cell.video = video;
                
                return cell;
            }
                
            default:
                break;
        }
    }
    
    return nil;
}

#pragma mark - Notifications
- (void)didUserLogin
{
    if ([[Account me] isAuthenticated]) {
        // Offset;
        [self.tableView setContentOffset:CGPointZero];
        
        // Load;
        [self loadPosts];
    }
}

#pragma mark - Actions
- (void)didSelectVideo:(Video *)video
{
    XCDYouTubeVideoPlayerViewController *viewController = [[XCDYouTubeVideoPlayerViewController alloc] initWithVideoIdentifier:video.identifier];
    
    // Present;
	[self presentMoviePlayerViewControllerAnimated:viewController];
}

- (void)didUser:(User *)user
{
    UserViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"UserViewController"];
    
    // Set;
    viewController.user = user;
    
    // Push;
    [self.navigationController pushViewController:viewController animated:YES];
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
            // Reload;
            [self.tableView reloadData];
        }];
    }
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
//          viewController.excludedActivityTypes = @[UIActivityTypePostToFacebook, UIActivityTypePostToTwitter, UIActivityTypeMail, UIActivityTypeMessage];
            viewController.completionHandler = ^(NSString *activityType, BOOL completed) {
                NSLog(@"%@", activityType);
            };
            
            // Present;
            [self presentViewController:viewController animated:YES completion:^{
                
            }];
        }
    }];
}

#pragma mark - Load
- (void)loadPosts
{
    // Set;
    last = 0;
    more = NO;
    
    // Animation;
    [refreshControl beginRefreshing];
    
    // Get;
    [APIClient getFeedReposts:last count:DEFAULT_COUNT completion:^(NSArray *posts) {
        // Set;
        Event *event = [posts lastObject];
        Video *video = event.target;
        
        last = video.objectId;
        more = [posts count] == DEFAULT_COUNT;
        
        // Animation;
        [refreshControl endRefreshing];

        // Posts;
        self.posts = [NSMutableArray arrayWithArray:posts];
        
        // Reload;
        [self.tableView reloadData];
    }];
}

- (void)loadMore
{
    [APIClient getFeedReposts:last count:DEFAULT_COUNT completion:^(NSArray *posts) {
        // Set;
        Event *event = [posts lastObject];
        Video *video = event.target;
        
        last = video.objectId;
        more = [posts count] == DEFAULT_COUNT;
        
        // Posts;
        [self.posts addObjectsFromArray:posts];
        
        // Reload;
        [self.tableView reloadData];
    }];
}

@end
