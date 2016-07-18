//
//  ForgotViewController.m
//  Warbl
//
//  Created by Xin ZhangZhe on 4/3/14.
//  Copyright (c) 2014 sptmbr LLC. All rights reserved.
//
// --- Headers ---;
#import "ForgotViewController.h"

#import "APIClient.h"
#import "Account.h"

#import "FUIButton.h"
#import "UIColor+FlatUI.h"

#import "MBProgressHUD.h"

// --- Defines ---;
// ForgotViewController Class;
@interface ForgotViewController ()

@end

@implementation ForgotViewController

// Functions;
#pragma mark - ForgotViewController
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
    
    // Content;
    viewForScroll.contentSize = viewForContent.bounds.size;
    
    // Buttons;
    [self loadButton:btnForForgot buttonColor:[UIColor colorFromHexCode:@"#1dc490"] shadowColor:[UIColor colorFromHexCode:@"#10b481"]];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // Notifications;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willShowKeyBoard:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willHideKeyBoard:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    // Notifications;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
    if (textField == txtForEmail) {
        [txtForEmail resignFirstResponder];
    }
    
    return YES;
}

#pragma mark - Notification
- (void)willShowKeyBoard:(NSNotification *)notification
{
    NSDictionary *userInfo = [notification userInfo];
    NSTimeInterval duration;
    UIViewAnimationCurve curve;
    CGRect keyboardFrame;
    CGRect frame = [viewForScroll frame];
    
    // Keyboard;
    [[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] getValue:&curve];
    [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&duration];
    [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardFrame];
    
    frame.size.height -= keyboardFrame.size.height - self.tabBarController.tabBar.frame.size.height;
    
    // Animation;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationCurve:curve];
    [UIView setAnimationDuration:duration];
    
    [viewForScroll setFrame:frame];
    
    [UIView commitAnimations];
}

- (void)willHideKeyBoard:(NSNotification *)notification
{
    NSDictionary *userInfo = [notification userInfo];
    NSTimeInterval duration;
    UIViewAnimationCurve curve;
    CGRect keyboardFrame;
    CGRect frame = [viewForScroll frame];
    
    // Keyboard;
    [[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] getValue:&curve];
    [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&duration];
    [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardFrame];
    
    frame.size.height += keyboardFrame.size.height - self.tabBarController.tabBar.frame.size.height;
    
    // Animation;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationCurve:curve];
    [UIView setAnimationDuration:duration];
    
    [viewForScroll setFrame:frame];
    
    [UIView commitAnimations];
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

#pragma mark - Check
- (BOOL)checkBlankField
{
    if ([txtForEmail.text isEqualToString:@""]) {
        [self showAlertWithTitle:nil message:@"Please fill email address."];
        return NO;
    }
    
    return YES;
}

- (void)resignResponders
{
    if ([txtForEmail isFirstResponder]) {
        [txtForEmail resignFirstResponder];
    }
}

#pragma mark - Events
- (IBAction)onBtnBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onBtnForgotPassword:(id)sender
{
    // Check;
    if (![self checkBlankField]) {
        return;
    }
    
    // Resign;
    [self resignResponders];
    
    // Show;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    // Forgot Password;
    [APIClient forgotPasswordForEmail:txtForEmail.text completion:^(BOOL successed) {
        // Hide;
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        // Forgot Password;
        if (successed) {
            // Back;
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            [self showAlertWithTitle:nil message:@"Internet Connection Error!"];
        }
    }];
}

@end
