//
//  SettingViewController.m
//  Warbl
//
//  Created by Xin ZhangZhe on 4/3/14.
//  Copyright (c) 2014 sptmbr LLC. All rights reserved.
//
// --- Headers ---;
#import "SettingViewController.h"

#import "APIClient.h"
#import "Account.h"

#import "FUIButton.h"
#import "UIColor+FlatUI.h"

#import "UIImageView+WebCache.h"

#import "MBProgressHUD.h"

// --- Defines ---;
// SettingViewController Class;
@interface SettingViewController ()

// Properties;
@property (nonatomic, strong) UIImage *avatar;

@end

@implementation SettingViewController

// Functions;
#pragma mark - SettingViewController
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
    
    // Avatar;
    imgForAvatar.layer.cornerRadius = 16.0f;
    imgForAvatar.layer.borderColor = DEFAULT_COLOR.CGColor;
    imgForAvatar.layer.borderWidth = 0.0f;
    
    // Video Quality;
    [self loadButton:btnForHD buttonColor:[UIColor concreteColor] shadowColor:[UIColor asbestosColor]];
    [self loadButton:btnForVariable buttonColor:[UIColor concreteColor] shadowColor:[UIColor asbestosColor]];
    [self loadButton:btnForSD buttonColor:[UIColor concreteColor] shadowColor:[UIColor asbestosColor]];
    [self loadButton:btnForLogout buttonColor:[UIColor colorFromHexCode:@"#1dc490"] shadowColor:[UIColor colorFromHexCode:@"#10b481"]];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Load;
    [self loadUser];
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

#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
        {
            UIImagePickerController *pickerController = [[UIImagePickerController alloc] init];
            
            pickerController.delegate = self;
            pickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
            pickerController.allowsEditing = YES;
            
            // Present;
            [self presentViewController:pickerController animated:YES completion:^{
                
            }];
            break;
        }
            
        case 1:
        {
            UIImagePickerController *pickerController = [[UIImagePickerController alloc] init];
            
            pickerController.delegate = self;
            pickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            pickerController.allowsEditing = YES;
            
            // Present;
            [self presentViewController:pickerController animated:YES completion:^{
                
            }];
            break;
        }
            
        default:
            break;
    }
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)pickerController didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    // Set;
    self.avatar = [info objectForKey:UIImagePickerControllerEditedImage];

    // UI;
    imgForAvatar.image = self.avatar;
    
    // Dismiss;
    [pickerController dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)pickerController
{
    // Dismiss;
    [pickerController dismissViewControllerAnimated:YES completion:^{
        
    }];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
    
    if (textField == txtForUsername) {
        [txtForName becomeFirstResponder];
    } else if (textField == txtForName) {
        [txtForEmail becomeFirstResponder];
    } else if (textField == txtForEmail) {
        [txtForNewPassword becomeFirstResponder];
    } else if (textField == txtForNewPassword) {
        [txtForConfirmpassword becomeFirstResponder];
    } else if (textField == txtForConfirmpassword) {
        [txtForConfirmpassword resignFirstResponder];
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
- (void)loadUser
{
    Account *me = [Account me];
    
    // Avatar;
    [imgForAvatar setImageWithURL:[NSURL URLWithString:me.avatar] placeholderImage:nil];
    
    // Info;
    txtForUsername.text = me.username;
    txtForName.text = me.name;
    txtForEmail.text = me.email;
}

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
- (BOOL)checkChanges
{
    Account *me = [Account me];
    NSInteger count = 0;
    
    if (self.avatar) {
        count++;
    }
    
    if (![txtForUsername.text isEqualToString:me.username]) {
        count++;
    }
    
    if (![txtForName.text isEqualToString:me.name]) {
        count++;
    }
    
    if (![txtForEmail.text isEqualToString:me.email]) {
        count++;
    }
    
    if (![txtForNewPassword.text isEqualToString:@""]) {
        count++;
    }
    
    return count;
}

- (BOOL)checkPassword
{
    if (![txtForNewPassword.text isEqualToString:txtForConfirmpassword.text]) {
        [self showAlertWithTitle:nil message:@"No Matched."];
        return NO;
    }
    
    if ([txtForNewPassword.text length] > 0 && [txtForNewPassword.text length] < 6) {
        [self showAlertWithTitle:nil message:@"Passwords must be at least 6 characters."];
        return NO;
    }
    
    return YES;
}

#pragma mark - Resign
- (void)resignResponders
{
    if ([txtForUsername isFirstResponder]) {
        [txtForUsername resignFirstResponder];
    } else if ([txtForName isFirstResponder]) {
        [txtForName resignFirstResponder];
    } else if ([txtForEmail isFirstResponder]) {
        [txtForEmail resignFirstResponder];
    } else if ([txtForNewPassword isFirstResponder]) {
        [txtForNewPassword resignFirstResponder];
    } else if ([txtForConfirmpassword isFirstResponder]) {
        [txtForConfirmpassword resignFirstResponder];
    }
}

#pragma mark - Events
- (IBAction)onBtnBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onBtnSave:(id)sender
{
    // Check;
    if (![self checkChanges]) {
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    
    if (![self checkPassword]) {
        return;
    }
    
    // Resign;
    [self resignResponders];

    // Show;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];

    // Sign Up;
    [APIClient saveProfileWithAvatar:self.avatar username:txtForUsername.text name:txtForName.text email:txtForEmail.text password:txtForNewPassword.text completion:^(AccountMessage message) {
        // Show;
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        switch (message) {
            case AccountMessageSuccessed:
                [[NSNotificationCenter defaultCenter] postNotificationName:@"didUpdateProfile" object:nil];
                [self.navigationController popViewControllerAnimated:YES];
                break;
                
            default:
                [self showAlertWithTitle:nil message:@"Invalid Connection"];
                break;
        }
    }];
}

- (IBAction)onBtnAvatar:(id)sender
{
    [[[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Take Photo" otherButtonTitles:@"Choose Existing Photo", nil] showFromTabBar:self.tabBarController.tabBar];
}

- (IBAction)onBtnLogout:(id)sender{

    // Logout;
    [[Account me] logout];
    
    // Notifications;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"didUserLogout" object:nil];
}

@end
