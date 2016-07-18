//
//  DetailCell.m
//  Warbl
//
//  Created by Xin ZhangZhe on 4/3/14.
//  Copyright (c) 2014 sptmbr LLC. All rights reserved.
//
// --- Headers ---;
#import "DetailCell.h"

#import "User.h"
#import "Video.h"

// --- Defines ---;
// DetailCell Class;
@implementation DetailCell

// Functions;
#pragma mark - DetailCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

    }
    return self;
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
    [btnForUsername setTitle:self.user.username forState:UIControlStateNormal];
}

- (void)setVideo:(Video *)video
{
    // Set;
    _video = video;
    
    // UI;
    [btnForPosts setTitle:[NSString stringWithFormat:@"%ld", (long)self.video.posts] forState:UIControlStateNormal];
    [btnForFavorites setTitle:[NSString stringWithFormat:@"%ld", (long)self.video.favorites] forState:UIControlStateNormal];

    // Repost;
    switch (self.video.posted) {
        case 0:
        case 1:
            btnForRepost.hidden = NO;
            btnForRepost.selected = self.video.posted;
            [activityForRepost stopAnimating];
            break;
            
        case 2:
            btnForRepost.hidden = YES;
            [activityForRepost startAnimating];
            break;
            
        default:
            break;
    }
    
    // Favorites;
    switch (self.video.favorited) {
        case 0:
        case 1:
            btnForFavorite.hidden = NO;
            btnForFavorite.selected = self.video.favorited;
            [activityForFavorite stopAnimating];
            break;
            
        case 2:
            btnForFavorite.hidden = YES;
            [activityForFavorite startAnimating];
            break;
            
        default:
            break;
    }
}

#pragma mark - Events
- (IBAction)onBtnUser:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(didUser:)]) {
        [self.delegate performSelector:@selector(didUser:) withObject:self.user];
    }
}

- (IBAction)onBtnRepost:(id)sender
{
    // UI;
    btnForRepost.hidden = YES;
    [activityForRepost startAnimating];
    
    // Reposting;
    if ([self.delegate respondsToSelector:@selector(didRepost:)]) {
        [self.delegate performSelector:@selector(didRepost:) withObject:self.video];
    }
}

- (IBAction)onBtnDelete:(id)sender
{
    if (self.video.posted) {
        // Deleting;
        if ([self.delegate respondsToSelector:@selector(didDelete:)]) {
            [self.delegate performSelector:@selector(didDelete:) withObject:self.video];
        }
    }
}

- (IBAction)onBtnFavorite:(id)sender
{
    // UI;
    btnForFavorite.hidden = YES;
    [activityForFavorite startAnimating];

    // Favoriting;
    if ([self.delegate respondsToSelector:@selector(didFavorite:)]) {
        [self.delegate performSelector:@selector(didFavorite:) withObject:self.video];
    }
}

- (IBAction)onBtnShare:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(didShare:)]) {
        [self.delegate performSelector:@selector(didShare:) withObject:self.video];
    }
}

@end
