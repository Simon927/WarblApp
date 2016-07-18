//
//  SearchResultController.m
//  Warbl
//
//  Created by Xin ZhangZhe on 4/3/14.
//  Copyright (c) 2014 sptmbr LLC. All rights reserved.
//
// --- Headers ---;
#import "SearchResultController.h"
#import "TitleCell.h"
#import "VideoCell.h"
#import "DetailCell.h"
#import "MoreCell.h"

#import "APIClient.h"
#import "Account.h"

#import "YouTubeService.h"
#import "VideoCategory.h"
#import "Video.h"

#import "XCDYouTubeVideoPlayerViewController.h"

#import "SDWebImageManager.h"

#import "ActivityItemProvider.h"

// --- Defines ---;
// SearchResultController Class;
@interface SearchResultController () <VideoCellDelegate, DetailCellDelegate>
{
    UIRefreshControl *refreshControl;
}

// Properties;
@property (nonatomic, strong) NSMutableArray *posts;
@property (nonatomic, strong) NSString *nextPageToken;

@end

@implementation SearchResultController

// Functions;
#pragma mark - SearchResultController
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
}

#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.nextPageToken) {
        return [self.posts count] + 1;
    }
    
    return [self.posts count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.nextPageToken && section == [self.posts count]) {
        return 1;
    }
    
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.nextPageToken && indexPath.section == [self.posts count]) {
        return 44.0f;
    } else {
        Video *video = self.posts[indexPath.section];
        
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
    if (self.nextPageToken && indexPath.section == [self.posts count]) {
        static NSString *MoreCellIdentifier = @"MoreCell";
        MoreCell *cell = [tableView dequeueReusableCellWithIdentifier:MoreCellIdentifier forIndexPath:indexPath];
        
        // Start;
        [cell startAnimating];
        
        // Load;
        [self loadMore];
        
        return cell;
    } else {
        Video *video = self.posts[indexPath.section];
        
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

#pragma mark - Actions
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
//          viewController.excludedActivityTypes = @[UIActivityTypePostToWeibo, UIActivityTypeAssignToContact, UIActivityTypePrint, UIActivityTypeCopyToPasteboard, UIActivityTypeSaveToCameraRoll];
            viewController.completionHandler = ^(NSString *activityType, BOOL completed) {
                
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
    [YouTubeService youTubeVideoForText:self.text inVideoCategory:self.videoCategory pageToken:nil completion:^(NSArray *posts, NSString *nextPageToken) {
        // Posts;
        self.posts = [NSMutableArray arrayWithArray:posts];
        
        // Next Page;
        self.nextPageToken = nextPageToken;

        // Reload;
        [self.tableView reloadData];
        
        // End;
        [refreshControl performSelector:@selector(endRefreshing) withObject:nil];
    }];
}

- (void)loadMore
{
    // Search;
    [YouTubeService youTubeVideoForText:self.text inVideoCategory:self.videoCategory pageToken:self.nextPageToken completion:^(NSArray *posts, NSString *nextPageToken) {
        // Posts;
        [self.posts addObjectsFromArray:posts];
        
        // Next Page;
        self.nextPageToken = nextPageToken;
        
        // Reload;
        [self.tableView reloadData];
    }];
}

#pragma mark - Events
- (IBAction)onBtnBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end