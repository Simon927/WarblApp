//
//  SignViewController.h
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
// SignViewController Class;
@interface SignViewController : UIViewController
{
    IBOutlet FUIButton *btnForFacebook;
    IBOutlet FUIButton *btnForEmail;
    IBOutlet FUIButton *btnForLogin;
}

@end
