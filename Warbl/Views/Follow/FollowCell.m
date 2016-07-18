//
//  FollowCell.m
//  Warbl
//
//  Created by Xin ZhangZhe on 4/3/14.
//  Copyright (c) 2014 sptmbr LLC. All rights reserved.
//
// --- Headers ---;
#import "FollowCell.h"

#import "User.h"

#import "UIButton+WebCache.h"
#import "TTTAttributedLabel.h"

// --- Defines ---;
// FollowCell Class;
@interface FollowCell () <TTTAttributedLabelDelegate>

@end

@implementation FollowCell

// Functions;
#pragma mark - FollowCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    // Avatar;
    btnForAvatar.layer.cornerRadius = 25.0f;
    btnForAvatar.layer.borderColor = DEFAULT_COLOR.CGColor;
    btnForAvatar.layer.borderWidth = 0.0f;
    btnForAvatar.imageView.contentMode = UIViewContentModeScaleAspectFill;
    
    // Comment;
    NSMutableDictionary *linkAttributes = [NSMutableDictionary dictionary];
    [linkAttributes setObject:[NSNumber numberWithInt:kCTUnderlineStyleNone] forKey:(id)kCTUnderlineStyleAttributeName];
    [linkAttributes setObject:(id)[UIColor blackColor].CGColor forKey:(id)kCTForegroundColorAttributeName];
    
    NSMutableDictionary *activeLinkAttributes = [NSMutableDictionary dictionary];
    [activeLinkAttributes setObject:[NSNumber numberWithInt:kCTUnderlineStyleNone] forKey:(id)kCTUnderlineStyleAttributeName];
    [activeLinkAttributes setObject:(id)[UIColor blueColor].CGColor forKey:(id)kCTForegroundColorAttributeName];
    
    lblForUsername.delegate = self;
    lblForUsername.linkAttributes = linkAttributes;
    lblForUsername.activeLinkAttributes = activeLinkAttributes;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

- (void)setUser:(User *)user
{
    // Set;
    _user = user;
    
    // UI;
    [btnForAvatar setImageWithURL:[NSURL URLWithString:self.user.avatar] forState:UIControlStateNormal];
    
    NSRange userRange = NSMakeRange(0, user.username.length);
    [lblForUsername setText:self.user.username afterInheritingLabelAttributesAndConfiguringWithBlock:^NSMutableAttributedString *(NSMutableAttributedString *mutableAttributedString) {
        UIFont *boldFont = [UIFont fontWithName:@"HelveticaNeue-Bold" size:14.0f];
        
        if (boldFont) {
            // User;
            [mutableAttributedString addAttribute:(NSString *)kCTFontAttributeName value:boldFont range:userRange];
            [mutableAttributedString addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)[UIColor blackColor].CGColor range:userRange];
        }
        
        return mutableAttributedString;
    }];
    
    [lblForUsername addLinkToURL:[NSURL URLWithString:@"user"] withRange:userRange];
    
    lblForFullname.text = self.user.name;
    
    switch (self.user.followed) {
        case 0:
            // Hidden;
            btnForFollow.hidden = NO;
            
            // Text;
            [btnForFollow setTitle:@"follow" forState:UIControlStateNormal];
            
            // Animation;
            [activityForFollow stopAnimating];
            break;
            
        case 1:
            // Hidden;
            btnForFollow.hidden = NO;
            
            // Text;
            [btnForFollow setTitle:@"unfollow" forState:UIControlStateNormal];
            
            // Animation;
            [activityForFollow stopAnimating];
            break;
            
        case 2:
            // Hidden;
            btnForFollow.hidden = YES;
            
            // Animation;
            [activityForFollow startAnimating];
            break;
            
        default:
            break;
    }
}

#pragma mark - TTTAttributedLabelDelegate
- (void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithURL:(NSURL *)url
{
    if ([url.absoluteString isEqualToString:@"user"]) {
        if ([self.delegate respondsToSelector:@selector(didUser:)]) {
            [self.delegate performSelector:@selector(didUser:) withObject:self.user];
        }
    }
}

#pragma mark - Events
- (IBAction)onBtnAvatar:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(didUser:)]) {
        [self.delegate performSelector:@selector(didUser:) withObject:self.user];
    }
}

- (IBAction)onBtnFollow:(id)sender
{
    // UI;
    btnForFollow.hidden = YES;
    [activityForFollow startAnimating];
    
    // Follow;
    if ([self.delegate respondsToSelector:@selector(didFollow:)]) {
        [self.delegate performSelector:@selector(didFollow:) withObject:self.user];
    }
}

@end
