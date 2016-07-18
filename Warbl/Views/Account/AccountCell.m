//
//  AccountCell.m
//  Warbl
//
//  Created by Xin ZhangZhe on 4/3/14.
//  Copyright (c) 2014 sptmbr LLC. All rights reserved.
//
// --- Headers ---;
#import <QuartzCore/QuartzCore.h>

#import "AccountCell.h"
#import "Account.h"

#import "UIImageView+WebCache.h"
#import "UIColor+FlatUI.h"

// --- Defines ---;
// AccountCell Class;
@implementation AccountCell

// Functions;
#pragma mark - AccountCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

    }
    return self;
}

- (void)dealloc
{

}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    // Mode;
    _mode = -1;

    // Avatar;
    imgForAvatar.layer.cornerRadius = 36.0f;
    imgForAvatar.layer.borderColor = DEFAULT_COLOR.CGColor;
    imgForAvatar.layer.borderWidth = 0.0f;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

#pragma mark - align
- (void)alignTextAndImageOfButton:(UIButton *)button
{
    CGFloat spacing = 6.0f;
    CGSize size;
    
    // Title;
    size = button.imageView.frame.size;
    button.titleEdgeInsets = UIEdgeInsetsMake(0.0, -size.width, -(size.height+spacing), 0.0);
    
    // Image;
    size = button.titleLabel.frame.size;
    button.imageEdgeInsets = UIEdgeInsetsMake(-(size.height+spacing), 0.0, 0.0, -size.width);
}

#pragma mark - Events
- (void)setAccount:(Account *)account
{
    // Set;
    _account = account;

    // Avatar;
    [imgForAvatar setImageWithURL:[NSURL URLWithString:self.account.avatar] placeholderImage:nil];
    
    // Name;
    lblForName.text = self.account.name;
    
    // Repost;
    [btnForRepost setTitle:[NSString stringWithFormat:@"%ld", (long)self.account.posts] forState:UIControlStateNormal];
    [self alignTextAndImageOfButton:btnForRepost];
    
    // Favorite;
    [btnForFavorite setTitle:[NSString stringWithFormat:@"%ld", (long)self.account.favorites] forState:UIControlStateNormal];
    [self alignTextAndImageOfButton:btnForFavorite];
    
    // Follow;
    [btnForFollow setTitle:[NSString stringWithFormat:@"%ld", (long)self.account.follows] forState:UIControlStateNormal];
    [self alignTextAndImageOfButton:btnForFollow];
}

- (void)setMode:(NSInteger)mode
{
    // Prev
    if (_mode != mode) {
        switch (_mode) {
            case 0:     // Reposts;
            {
                [btnForRepost setImage:[UIImage imageNamed:@"profile_repost"] forState:UIControlStateNormal];
                [btnForRepost setTitleColor:[UIColor colorFromHexCode:@"b3b3b3"] forState:UIControlStateNormal];
                [btnForRepost setAdjustsImageWhenHighlighted:YES];
                break;
            }
                
            case 1:
            {
                [btnForFavorite setImage:[UIImage imageNamed:@"profile_favorite"] forState:UIControlStateNormal];
                [btnForFavorite setTitleColor:[UIColor colorFromHexCode:@"b3b3b3"] forState:UIControlStateNormal];
                [btnForFavorite setAdjustsImageWhenHighlighted:YES];
                break;
            }
                
            case 2:
            {
                [btnForFollow setImage:[UIImage imageNamed:@"profile_follow"] forState:UIControlStateNormal];
                [btnForFollow setTitleColor:[UIColor colorFromHexCode:@"b3b3b3"] forState:UIControlStateNormal];
                [btnForFollow setAdjustsImageWhenHighlighted:YES];
                break;
            }
                
            default:
                break;
        }
    }
    
    // Current;
    if (_mode != mode) {
        _mode = mode;
        
        switch (_mode) {
            case 0:
            {
                [btnForRepost setImage:[UIImage imageNamed:@"profile_repost_selected"] forState:UIControlStateNormal];
                [btnForRepost setTitleColor:DEFAULT_COLOR forState:UIControlStateNormal];
                [btnForRepost setAdjustsImageWhenHighlighted:NO];
                break;
            }
                
            case 1:
            {
                [btnForFavorite setImage:[UIImage imageNamed:@"profile_favorite_selected"] forState:UIControlStateNormal];
                [btnForFavorite setTitleColor:DEFAULT_COLOR forState:UIControlStateNormal];
                [btnForFavorite setAdjustsImageWhenHighlighted:NO];
                break;
            }
                
            case 2:
            {
                [btnForFollow setImage:[UIImage imageNamed:@"profile_follow_selected"] forState:UIControlStateNormal];
                [btnForFollow setTitleColor:DEFAULT_COLOR forState:UIControlStateNormal];
                [btnForFollow setAdjustsImageWhenHighlighted:NO];
                break;
            }
                
            default:
                break;
        }
    }
}

#pragma mark - Events
- (IBAction)onBtnReposts:(id)sender
{
    if (self.mode == 0) {
        return;
    }
    
    if ([self.delegate respondsToSelector:@selector(didReposts)]) {
        [self.delegate performSelector:@selector(didReposts) withObject:nil];
    }
}

- (IBAction)onBtnFavorites:(id)sender
{
    if (self.mode == 1) {
        return;
    }

    if ([self.delegate respondsToSelector:@selector(didFavorites)]) {
        [self.delegate performSelector:@selector(didFavorites) withObject:nil];
    }
}

- (IBAction)onBtnFollows:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(didFollows)]) {
        [self.delegate performSelector:@selector(didFollows) withObject:nil];
    }
}

@end
