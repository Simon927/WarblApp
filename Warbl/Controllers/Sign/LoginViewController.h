//
//  LoginViewController.h
//  Warbl
//
//  Created by Xin ZhangZhe on 4/3/14.
//  Copyright (c) 2014 sptmbr LLC. All rights reserved.
//
// --- Headers ---;
#import <UIKit/UIKit.h>

// --- Classes ---;
@class FUIButton;

// --- Defines ---;
// LoginViewController Class;
@interface LoginViewController : UIViewController <UITextFieldDelegate>
{
    IBOutlet UIScrollView *viewForScroll;
    IBOutlet UIView *viewForContent;
    IBOutlet UITextField *txtForUsername;
    IBOutlet UITextField *txtForPassword;
    IBOutlet UIButton *btnForSecure;
    IBOutlet FUIButton *btnForLogin;
    IBOutlet UIButton *btnForForgot;
}

@end
