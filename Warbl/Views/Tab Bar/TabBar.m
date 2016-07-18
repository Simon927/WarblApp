//
//  TabBar.m
//  Warbl
//
//  Created by Xin ZhangZhe on 4/3/14.
//  Copyright (c) 2014 sptmbr LLC. All rights reserved.
//
// --- Headers ---;
#import "TabBar.h"

// --- Defines ---;
// TabBar Class;
@interface TabBar ()

@end

@implementation TabBar

// Functions;
#pragma mark - TabBar
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _selectedIndex = -1;
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        _selectedIndex = -1;
    }
    return self;
}

- (void)dealloc
{
    self.delegate = nil;
}

#pragma mark - Set
- (void)setSelectedIndex:(NSUInteger)selectedIndex
{
    // Prev
    if (_selectedIndex != selectedIndex) {
        switch (_selectedIndex) {
            case 0:
            {
                [btnForFeed setImage:[UIImage imageNamed:@"tabbar_feed"] forState:UIControlStateNormal];
                [btnForFeed setBackgroundImage:[UIImage imageNamed:@"tabbar_background"] forState:UIControlStateNormal];
                [btnForFeed setBackgroundImage:[UIImage imageNamed:@"tabbar_background"] forState:UIControlStateHighlighted];
                [btnForFeed setAdjustsImageWhenHighlighted:YES];
                break;
            }
                
            case 1:
            {
                [btnForFeatured setImage:[UIImage imageNamed:@"tabbar_featured"] forState:UIControlStateNormal];
                [btnForFeatured setBackgroundImage:[UIImage imageNamed:@"tabbar_background"] forState:UIControlStateNormal];
                [btnForFeatured setBackgroundImage:[UIImage imageNamed:@"tabbar_background"] forState:UIControlStateHighlighted];
                [btnForFeatured setAdjustsImageWhenHighlighted:YES];
            }
                break;
                
            case 2:
            {
                [btnForAccount setImage:[UIImage imageNamed:@"tabbar_account"] forState:UIControlStateNormal];
                [btnForAccount setBackgroundImage:[UIImage imageNamed:@"tabbar_background"] forState:UIControlStateNormal];
                [btnForAccount setBackgroundImage:[UIImage imageNamed:@"tabbar_background"] forState:UIControlStateHighlighted];
                [btnForAccount setAdjustsImageWhenHighlighted:YES];
                break;
            }
                
            case 3:
            {
                [btnForFollow setImage:[UIImage imageNamed:@"tabbar_follow"] forState:UIControlStateNormal];
                [btnForFollow setBackgroundImage:[UIImage imageNamed:@"tabbar_background"] forState:UIControlStateNormal];
                [btnForFollow setBackgroundImage:[UIImage imageNamed:@"tabbar_background"] forState:UIControlStateHighlighted];
                [btnForFollow setAdjustsImageWhenHighlighted:YES];
                break;
            }

            case 4:
            {
                [btnForNotification setImage:[UIImage imageNamed:@"tabbar_notification"] forState:UIControlStateNormal];
                [btnForNotification setBackgroundImage:[UIImage imageNamed:@"tabbar_background"] forState:UIControlStateNormal];
                [btnForNotification setBackgroundImage:[UIImage imageNamed:@"tabbar_background"] forState:UIControlStateHighlighted];
                [btnForNotification setAdjustsImageWhenHighlighted:YES];
                break;
            }
                
            default:
                break;
        }
    }
    
    // Current;
    if (_selectedIndex != selectedIndex) {
        _selectedIndex = selectedIndex;
        
        switch (_selectedIndex) {
            case 0:
            {
                [btnForFeed setImage:[UIImage imageNamed:@"tabbar_feed_selected"] forState:UIControlStateNormal];
                [btnForFeed setBackgroundImage:[UIImage imageNamed:@"tabbar_background_selected"] forState:UIControlStateNormal];
                [btnForFeed setBackgroundImage:[UIImage imageNamed:@"tabbar_background_selected"] forState:UIControlStateHighlighted];
                [btnForFeed setAdjustsImageWhenHighlighted:NO];
                break;
            }
                
            case 1:
            {
                [btnForFeatured setImage:[UIImage imageNamed:@"tabbar_featured_selected"] forState:UIControlStateNormal];
                [btnForFeatured setBackgroundImage:[UIImage imageNamed:@"tabbar_background_selected"] forState:UIControlStateNormal];
                [btnForFeatured setBackgroundImage:[UIImage imageNamed:@"tabbar_background_selected"] forState:UIControlStateHighlighted];
                [btnForFeatured setAdjustsImageWhenHighlighted:NO];
                break;
            }
                
            case 2:
            {
                [btnForAccount setImage:[UIImage imageNamed:@"tabbar_account_selected"] forState:UIControlStateNormal];
                [btnForAccount setBackgroundImage:[UIImage imageNamed:@"tabbar_background_selected"] forState:UIControlStateNormal];
                [btnForAccount setBackgroundImage:[UIImage imageNamed:@"tabbar_background_selected"] forState:UIControlStateHighlighted];
                [btnForAccount setAdjustsImageWhenHighlighted:NO];
                break;
            }
                
            case 3:
            {
                [btnForFollow setImage:[UIImage imageNamed:@"tabbar_follow_selected"] forState:UIControlStateNormal];
                [btnForFollow setBackgroundImage:[UIImage imageNamed:@"tabbar_background_selected"] forState:UIControlStateNormal];
                [btnForFollow setBackgroundImage:[UIImage imageNamed:@"tabbar_background_selected"] forState:UIControlStateHighlighted];
                [btnForFollow setAdjustsImageWhenHighlighted:NO];
                break;
            }
                
            case 4:
            {
                [btnForNotification setImage:[UIImage imageNamed:@"tabbar_notification_selected"] forState:UIControlStateNormal];
                [btnForNotification setBackgroundImage:[UIImage imageNamed:@"tabbar_background_selected"] forState:UIControlStateNormal];
                [btnForNotification setBackgroundImage:[UIImage imageNamed:@"tabbar_background_selected"] forState:UIControlStateHighlighted];
                [btnForNotification setAdjustsImageWhenHighlighted:NO];
                break;
            }
                
            default:
                break;
        }
    }
    
    if ([self.delegate respondsToSelector:@selector(tabBar:didSelectIndex:)]) {
        [self.delegate tabBar:self didSelectIndex:_selectedIndex];
    }
}

#pragma mark - Events
- (IBAction)onBtnFeed:(id)sender
{
    self.selectedIndex = 0;
}

- (IBAction)onBtnFeatured:(id)sender
{
    self.selectedIndex = 1;
}

- (IBAction)onBtnAccount:(id)sender
{
    self.selectedIndex = 2;
}

- (IBAction)onBtnFollow:(id)sender
{
    self.selectedIndex = 3;
}

- (IBAction)onBtnNotification:(id)sender
{
    self.selectedIndex = 4;
}

@end
