//
//  TitleCell.m
//  Warbl
//
//  Created by Xin ZhangZhe on 4/3/14.
//  Copyright (c) 2014 sptmbr LLC. All rights reserved.
//
// --- Headers ---;
#import "TitleCell.h"

#import "Video.h"

// --- Defines ---;
// TitleCell Class;
@implementation TitleCell

// Functions;
#pragma mark - Shared Functions
+ (CGFloat)heightForVideo:(Video *)video
{
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue" size:15.0f]};
    CGRect rect = [video.title boundingRectWithSize:CGSizeMake(290.0f, 999.0f) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:	nil];
    CGFloat height = rect.size.height;
    
    return height < 32.0f ? 32.0f : height + 16.0f;
}

#pragma mark - TitleCell
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

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

- (void)setVideo:(Video *)video
{
    // Set;
    _video = video;
    
    // UI;
    self.textLabel.text = video.title;
}

@end
