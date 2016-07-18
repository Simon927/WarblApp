//
//  SettingViewController.h
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
// SettingViewController Class;
@interface SettingViewController : UIViewController <UIActionSheetDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate>
{
    IBOutlet UIScrollView *viewForScroll;
    IBOutlet UIView *viewForContent;
    
    IBOutlet UIImageView *imgForAvatar;
    IBOutlet UIButton *btnForAvatar;
    
    IBOutlet UITextField *txtForUsername;
    IBOutlet UITextField *txtForName;
    IBOutlet UITextField *txtForEmail;
    IBOutlet UITextField *txtForNewPassword;
    IBOutlet UITextField *txtForConfirmpassword;
    
    IBOutlet FUIButton *btnForHD;
    IBOutlet FUIButton *btnForVariable;
    IBOutlet FUIButton *btnForSD;
    
    IBOutlet FUIButton *btnForLogout;
}

@end
