//
//  InviteViewController.m
//  Warbl
//
//  Created by Xin ZhangZhe on 4/3/14.
//  Copyright (c) 2014 sptmbr LLC. All rights reserved.
//
// --- Headers ---;
#import <FacebookSDK/FacebookSDK.h>

#import "InviteViewController.h"
#import "FollowCell.h"
#import "MoreCell.h"

#import "UserViewController.h"

#import "APIClient.h"
#import "User.h"

#import "FUIButton.h"
#import "UIColor+FlatUI.h"

// --- Defines ---;
// InviteViewController Class;
@interface InviteViewController () <FollowCellDelegate>
{
    BOOL more;
}

// Properties;
@property (nonatomic, strong) NSMutableArray *follows;

@end

@implementation InviteViewController

// Functions;
#pragma mark - InviteViewController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

    }
    return self;
}

- (void)loadView
{
    [super loadView];
    
    // Buttons;
    [self loadButton:btnFacebook buttonColor:[UIColor colorFromHexCode:@"#26599a"] shadowColor:[UIColor colorFromHexCode:@"#214f89"]];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Navigation Bar;
    if ([self.navigationController.viewControllers firstObject] == self) {
        self.navigationItem.leftBarButtonItem = nil;
    }
    
    if (!self.skipped) {
        self.navigationItem.rightBarButtonItem = nil;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];

}

- (void)dealloc
{

}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == txtForSearch) {
        [txtForSearch resignFirstResponder];
        
        // Search;
        if (![txtForSearch.text isEqualToString:@""]) {
            viewForFacebook.hidden = YES;
            tblForFollow.hidden = NO;
            
            [self loadFollows];
        }
    }
    
    return YES;
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
            [tblForFollow reloadData];
            
            // Notification;
            [[NSNotificationCenter defaultCenter] postNotificationName:@"didFollowUser" object:user];
        }];
    } else {
        [APIClient unfollowUser:user completion:^(BOOL finished) {
            // Reload;
            [tblForFollow reloadData];
            
            // Notification;
            [[NSNotificationCenter defaultCenter] postNotificationName:@"didUnfollowUser" object:user];

        }];
    }
}

#pragma mark - Load
- (void)loadButton:(FUIButton *)button buttonColor:(UIColor *)buttonColor shadowColor:(UIColor *)shadowColor
{
    button.buttonColor = buttonColor;
    button.shadowColor = shadowColor;
    button.highlightedColor = shadowColor;
    button.shadowHeight = 3.0f;
    button.cornerRadius = 6.0f;
}

#pragma mark - Load
- (void)loadFollows
{
    // Get;
    [APIClient searchFriends:txtForSearch.text number:0 count:DEFAULT_COUNT completion:^(NSArray *follows) {
        // Follows;
        self.follows = [NSMutableArray arrayWithArray:follows];
        
        // More;
        more = [follows count] == DEFAULT_COUNT;
        
        // Reload;
        [tblForFollow reloadData];
    }];
}

- (void)loadMore
{
    [APIClient searchFriends:txtForSearch.text number:[self.follows count] count:DEFAULT_COUNT completion:^(NSArray *follows) {
        // Follows;
        [self.follows addObjectsFromArray:follows];
        
        // More;
        more = [follows count] == DEFAULT_COUNT;
        
        // Reload;
        [tblForFollow reloadData];
    }];
}

#pragma mark - Facebook
- (void)signInFacebook
{
    if (![FBSession activeSession].isOpen) {
        if (![FBSession activeSession].state != FBSessionStateCreated) {
            FBSession *session = [[FBSession alloc] initWithPermissions:@[@"email", @"publish_actions", @"read_friendlists", @"user_relationships"]];
            
            // Set;
            [FBSession setActiveSession:session];
        }
        
        // Login;
        [[FBSession activeSession] openWithCompletionHandler:^(FBSession *session, FBSessionState status, NSError *error) {
            if (error) {
                
            } else {
                [self fetchFriends];
            }
        }];
    } else {
        [self fetchFriends];
    }
}

- (void)fetchFriends
{
    [FBRequestConnection startForMyFriendsWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        if (error) {
            
        } else {
            
        }
    }];
}

#pragma mark - Events
- (IBAction)onBtnBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onBtnFacebook:(id)sender
{
    
}

@end
