//
//  RegisterViewController.m
//  Warbl
//
//  Created by Xin ZhangZhe on 4/3/14.
//  Copyright (c) 2014 sptmbr LLC. All rights reserved.
//
// --- Headers ---;
#import "RegisterViewController.h"
#import "InviteViewController.h"

#import "APIClient.h"
#import "Account.h"

#import "FUIButton.h"
#import "UIColor+FlatUI.h"

#import "MBProgressHUD.h"

// --- Defines ---;
// RegisterViewController Class;
@interface RegisterViewController ()

// Properties;
@property (nonatomic, strong) UIImage *avatar;

@end

@implementation RegisterViewController
// Functions;
#pragma mark - RegisterViewController
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
    btnForAvatar.layer.cornerRadius = 40.0f;
    btnForAvatar.layer.borderColor = DEFAULT_COLOR.CGColor;
    btnForAvatar.layer.borderWidth = 0.0f;

    // Buttons;
    [self loadButton:btnForRegister buttonColor:[UIColor colorFromHexCode:@"#1dc490"] shadowColor:[UIColor colorFromHexCode:@"#10b481"]];
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
    [btnForAvatar setImage:self.avatar forState:UIControlStateNormal];
    
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
    if (textField == txtForUsername) {
        [txtForPassword becomeFirstResponder];
    } else if (textField == txtForPassword) {
        [txtForEmail becomeFirstResponder];
    } else if (textField == txtForEmail) {
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
    NSArray *fields = [NSArray arrayWithObjects:txtForUsername, txtForPassword, txtForEmail, nil];
//  NSArray *titles = [NSArray arrayWithObjects:@"Username", @"Password", @"Email", nil];
    
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

- (void)checkUsername
{
    
}

- (BOOL)checkEmail
{
    BOOL filter = YES;
    NSString *filterString = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSString *laxString = @".+@.+\\.[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = filter ? filterString : laxString;
    NSPredicate* emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    
    if (![emailTest evaluateWithObject:txtForEmail.text])
    {
        [self showAlertWithTitle:nil message:@"Input a valid Email address."];
        return NO;
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
    } else if ([txtForEmail isFirstResponder]) {
        [txtForEmail resignFirstResponder];
    }
}

#pragma mark - Events
- (IBAction)onBtnBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onBtnRegister:(id)sender
{
    // Check;
    if (![self checkBlankField]) {
        return;
    }
    
    if (![self checkPassword]) {
        return;
    }

    if (![self checkEmail]) {
        return;
    }
    
    // Resign;
    [self resignResponders];
    
    // Show;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    // Regiser;
    [APIClient signUpWithAvatar:self.avatar username:txtForUsername.text password:txtForPassword.text email:txtForEmail.text completion:^(Account *account, AccountMessage message) {
        // Show;
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        switch (message) {
            case AccountMessageSuccessed:
                [[NSNotificationCenter defaultCenter] postNotificationName:@"didUserLogin" object:nil];
                break;

            case AccountMessageInvalidConnection:
                [self showAlertWithTitle:nil message:@"Invalid Connection"];
                break;
                
            case AccountMessageInvalidUsername:
                [self showAlertWithTitle:nil message:@"Invalid Username"];
                break;
                
            case AccountMessageInvalidEmail:
                [self showAlertWithTitle:nil message:@"Invalid Email"];
                break;
                
            case AccountMessageInvaildUserInfo:
                [self showAlertWithTitle:nil message:@"Invalid Userinfo"];
                break;
                
            default:
                break;
        }
    }];
}

- (IBAction)onBtnAvatar:(id)sender
{
    [[[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Take Photo" otherButtonTitles:@"Choose Existing Photo", nil] showFromTabBar:self.tabBarController.tabBar];
}

- (IBAction)onBtnSecure:(id)sender
{
    NSString *title = [txtForPassword isSecureTextEntry] ? @"Hide" : @"Show";
    
    // Set;
    txtForPassword.secureTextEntry = ![txtForPassword isSecureTextEntry];
    [btnForSecure setTitle:title forState:UIControlStateNormal];
}

@end
