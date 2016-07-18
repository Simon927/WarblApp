//
//  SearchViewController.m
//  Warbl
//
//  Created by Xin ZhangZhe on 4/3/14.
//  Copyright (c) 2014 sptmbr LLC. All rights reserved.
//
// --- Headers ---;
#import "SearchViewController.h"
#import "VideoCategoryCell.h"

#import "SearchResultController.h"

#import "YouTubeService.h"
#import "VideoCategory.h"

#import "MBProgressHUD.h"

// --- Defines ---;
// FeaturedViewController Class;
@interface SearchViewController ()

// Properties;
@property (nonatomic, strong) NSArray *videoCategories;
@property (nonatomic, weak) VideoCategory *videoCategory;

@end

@implementation SearchViewController

// Functions;
#pragma mark - FeaturedViewController
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
    
    // Set;
    self.view.backgroundColor = DEFAULT_COLOR;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Load;
    [self loadCategories];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // Notifications;
//  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willShowKeyBoard:) name:UIKeyboardWillShowNotification object:nil];
//  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willHideKeyBoard:) name:UIKeyboardWillHideNotification object:nil];

    // Deselect;
    [tblForCategory deselectRowAtIndexPath:[tblForCategory indexPathForSelectedRow] animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    // Notifications;
//  [[NSNotificationCenter defaultCenter] removeObserver:self];
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

        // Perform;
        if (![txtForSearch.text isEqualToString:@""]) {
            SearchResultController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"SearchResultController"];
            
            // Set;
            viewController.text = txtForSearch.text;
            
            [self.navigationController pushViewController:viewController animated:YES];
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
    return [self.videoCategories count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *TitleCellIdentifier = @"VideoCategoryCell";
    VideoCategoryCell *cell = [tableView dequeueReusableCellWithIdentifier:TitleCellIdentifier forIndexPath:indexPath];
    
    // Set;
    cell.videoCategory = self.videoCategories[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SearchResultController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"SearchResultController"];
    
    // Set;
    viewController.videoCategory = self.videoCategories[indexPath.row];
    
    [self.navigationController pushViewController:viewController animated:YES];
}

#pragma mark - Notification
- (void)willShowKeyBoard:(NSNotification *)notification
{
    NSDictionary *userInfo = [notification userInfo];
    NSTimeInterval duration = 0.15;
    UIViewAnimationCurve curve;
    CGRect keyboardFrame;
    CGRect frame = [viewForContent frame];
    
    // Keyboard;
    [[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] getValue:&curve];
    [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardFrame];
    
    frame.origin.y = 20;
    frame.size.height = frame.size.height + 44;
    
    // Navigation Bar;
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    // Content;
    [UIView animateWithDuration:duration animations:^{
        [viewForContent setFrame:frame];
    }];
}

- (void)willHideKeyBoard:(NSNotification *)notification
{
    NSDictionary *userInfo = [notification userInfo];
    NSTimeInterval duration = 0.15;
    UIViewAnimationCurve curve;
    CGRect keyboardFrame;
    CGRect frame = [viewForContent frame];
    
    // Keyboard;
    [[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] getValue:&curve];
    [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardFrame];
    
    frame.origin.y = 0;
    frame.size.height = frame.size.height - 44;
    
    // Navigation Bar;
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    // Content;
    [UIView animateWithDuration:duration animations:^{
        [viewForContent setFrame:frame];
    }];
}

#pragma mark - Load
- (void)loadCategories
{
    // Show;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    // Categories;
    [YouTubeService youTubeVideoCategoriesWithCompletion:^(NSArray *videoCategories) {
        // Hide;
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        // Set;
        self.videoCategories = videoCategories;
        
        // Reload;
        [tblForCategory reloadData];
    }];
}

- (IBAction)onBtnBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
