//
//  ForgotViewController.h
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
// ForgotViewController Class;
@interface ForgotViewController : UIViewController <UITextFieldDelegate>
{
    IBOutlet UIScrollView *viewForScroll;
    IBOutlet UIView *viewForContent;
    IBOutlet UITextField *txtForEmail;
    IBOutlet FUIButton *btnForForgot;
}

@end
