//
//  LoginViewController.m
//  Warbl
//
//  Created by Xin ZhangZhe on 4/3/14.
//  Copyright (c) 2014 sptmbr LLC. All rights reserved.
//
// --- Headers ---;
#import "LoginViewController.h"

#import "APIClient.h"
#import "Account.h"

#import "FUIButton.h"
#import "UIColor+FlatUI.h"

#import "MBProgressHUD.h"

// --- Defines ---;
// LoginViewController Class;
@interface LoginViewController ()

@end

@implementation LoginViewController

// Functions;
#pragma mark - LoginViewController
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
    [self loadButton:btnForLogin buttonColor:[UIColor colorFromHexCode:@"#1dc490"] shadowColor:[UIColor colorFromHexCode:@"#10b481"]];
    
    [btnForForgot setTitleColor:[UIColor colorFromHexCode:@"#1dc490"] forState:UIControlStateNormal];
    [btnForForgot setTitleColor:[UIColor colorFromHexCode:@"#10b481"] forState:UIControlStateHighlighted];
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
    if (textField == txtForUsername) {
        [txtForPassword becomeFirstResponder];
    } else if (textField == txtForPassword) {
        [txtForPassword resignFirstResponder];
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
    NSArray *fields = [NSArray arrayWithObjects:txtForUsername, txtForPassword, nil];
//  NSArray *titles = [NSArray arrayWithObjects:@"Username", @"Password", nil];
    
    for (NSInteger i = 0; i < [fields count]; i++) {
        UITextField *field = fields[i];
//      NSString *title = [titles objectAtIndex:i];
        
        if ([field.text isEqualToString:@""]) {
            [self showAlertWithTitle:nil message:@"Please fill in all the details."];
            return NO;
        }
    }
    
    return YES;
}

- (BOOL)checkPassword
{
    if ([txtForPassword.text length] < 6) {
        [self showAlertWithTitle:nil message:@"Passwords must be at least 6 characters."];
        return NO;
    }
    
    return YES;
}

- (void)resignResponders
{
    if ([txtForUsername isFirstResponder]) {
        [txtForUsername resignFirstResponder];
    } else if ([txtForPassword isFirstResponder]) {
        [txtForPassword resignFirstResponder];
    }
}

#pragma mark - Events
- (IBAction)onBtnBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onBtnLogin:(id)sender
{
    // Check;
    if (![self checkBlankField]) {
        return;
    }
    
    if (![self checkPassword]) {
        return;
    }
    
    // Resign;
    [self resignResponders];
    
    // Show;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    // Login;
    [APIClient signInWithUsername:txtForUsername.text password:txtForPassword.text completion:^(Account *account, AccountMessage message) {
        // Show;
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        switch (message) {
            case AccountMessageSuccessed:
                [[NSNotificationCenter defaultCenter] postNotificationName:@"didUserLogin" object:nil];
                break;
                
            case AccountMessageInvalidConnection:
                [self showAlertWithTitle:nil message:@"Invalid Connection"];
                break;
                
            default:
                [self showAlertWithTitle:nil message:@"Invalid Username/Password"];
                break;
        }
    }];
}

- (IBAction)onBtnSecure:(id)sender
{
    NSString *title = [txtForPassword isSecureTextEntry] ? @"Hide" : @"Show";
    
    // Set;
    txtForPassword.secureTextEntry = ![txtForPassword isSecureTextEntry];
    [btnForSecure setTitle:title forState:UIControlStateNormal];
}

@end
