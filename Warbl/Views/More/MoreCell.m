//
//  MoreCell.m
//  Warbl
//
//  Created by Xin ZhangZhe on 4/3/14.
//  Copyright (c) 2014 sptmbr LLC. All rights reserved.
//
// --- Headers ---;
#import "MoreCell.h"

// --- Defines ---;
// MoreCell Class;
@implementation MoreCell

// Functions;
#pragma mark - MoreCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

    }
    return self;
}

- (void)awakeFromNib
{

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

- (void)startAnimating
{
    [activityIndicatorView startAnimating];
}

- (void)stopAnimating
{
    [activityIndicatorView stopAnimating];
}

@end
