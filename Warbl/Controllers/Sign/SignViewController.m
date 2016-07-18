//
//  SignViewController.m
//  Warbl
//
//  Created by Xin ZhangZhe on 4/3/14.
//  Copyright (c) 2014 sptmbr LLC. All rights reserved.
//
// --- Headers ---;
#import <FacebookSDK/FacebookSDK.h>

#import "SignViewController.h"

#import "APIClient.h"
#import "Account.h"

#import "FUIButton.h"
#import "UIColor+FlatUI.h"

#import "MBProgressHUD.h"

// --- Defines ---;
// SignViewController Class;
@interface SignViewController ()

@end

@implementation SignViewController

// Functions;
#pragma mark - SignViewController
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
    [self loadButton:btnForFacebook buttonColor:[UIColor colorFromHexCode:@"#26599a"] shadowColor:[UIColor colorFromHexCode:@"#204d86"]];
    [self loadButton:btnForEmail buttonColor:[UIColor colorFromHexCode:@"#1dc490"] shadowColor:[UIColor colorFromHexCode:@"#10b481"]];
    [self loadButton:btnForLogin buttonColor:[UIColor colorFromHexCode:@"#1dc490"] shadowColor:[UIColor colorFromHexCode:@"#10b481"]];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
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

#pragma mark - Alert Tips
- (void)showAlertWithTitle:(NSString *)title message:(NSString *)message
{
    [[[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show];
}

#pragma mark - Sign
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
                // Hide;
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                
                [self showAlertWithTitle:nil message:@"Invalid Connection!"];
            } else {
                [self fetchProfile];
            }
        }];
    } else {
        [self fetchProfile];
    }
}

- (void)fetchProfile
{
    [FBRequestConnection startForMeWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        if (error) {
            // Hide;
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
            [self showAlertWithTitle:nil message:@"Invalid Connection!"];
        } else {
            id profile = result;
            FBRequest* friendsRequest = [FBRequest requestWithGraphPath:@"me/friends?fields=installed" parameters:nil HTTPMethod:@"GET"];
            
            [friendsRequest startWithCompletionHandler: ^(FBRequestConnection *connection, NSDictionary* result, NSError *error) {
                NSMutableArray *friends = [NSMutableArray array];
                NSArray *users = [result objectForKey:@"data"];
                
                for (NSDictionary<FBGraphUser>* user in users) {
                    if (user[@"installed"]) {
                        [friends addObject:user.id];
                    }
                }
                
                [self signInFacebookWithProfile:profile withFriends:friends];
            }];
        }
    }];
}

- (void)signInFacebookWithProfile:(id)profile withFriends:(NSArray *)friends
{
    [APIClient signInFacebookWithUsername:profile[@"username"] name:profile[@"name"] email:profile[@"email"] facebookId:profile[@"id"] friends:friends completion:^(Account *account, AccountMessage message) {
        // Hide;
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        switch (message) {
            case AccountMessageSuccessed:
                [[NSNotificationCenter defaultCenter] postNotificationName:@"didUserLogin" object:nil];
                break;
                
            default:
                [self showAlertWithTitle:nil message:@"Invalid Connection!"];
                break;
        }
    }];
}

#pragma mark - Events
- (IBAction)onBtnFacebook:(id)sender
{
    // Show;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];

    // Register;
    [self signInFacebook];
}

@end
