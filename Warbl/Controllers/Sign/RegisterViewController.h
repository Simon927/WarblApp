//
//  RegisterViewController.h
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
// RegisterViewController Class;
@interface RegisterViewController : UIViewController <UIActionSheetDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate>
{
    IBOutlet UIScrollView *viewForScroll;
    IBOutlet UIView *viewForContent;
    IBOutlet UIButton *btnForAvatar;
    IBOutlet UITextField *txtForUsername;
    IBOutlet UITextField *txtForPassword;
    IBOutlet UIButton *btnForSecure;    
    IBOutlet UITextField *txtForEmail;
    IBOutlet FUIButton *btnForRegister;
}

@end
