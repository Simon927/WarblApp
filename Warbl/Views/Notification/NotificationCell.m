//
//  NotificationCell.m
//  Warbl
//
//  Created by Xin ZhangZhe on 4/3/14.
//  Copyright (c) 2014 sptmbr LLC. All rights reserved.
//
// --- Headers ---;
#import "NotificationCell.h"
#import "User.h"
#import "Video.h"
#import "Event.h"

#import "UIButton+WebCache.h"
#import "TTTAttributedLabel.h"

// --- Defines ---;
// NotificationCell Class;
@interface NotificationCell () <TTTAttributedLabelDelegate>

@end

@implementation NotificationCell

// Functions;
+ (CGFloat)heightForVideo:(Event *)event
{
    NSString *text = nil;
    
    switch (event.action) {
        case 0:     // Posted;
        {
            // Set;
            User *user = event.user;
            Video *target = event.target;
            
            // Text;
            text = [NSString stringWithFormat:@"%@ posted %@", user.username, target.title];
            break;
        }
            
        case 1:     // Favorited;
        {
            // Set;
            User *user = event.user;
            Video *target = event.target;
            
            // Text;
            text = [NSString stringWithFormat:@"%@ favorited %@", user.username, target.title];
            break;
        }
            
        case 2:     // Followed;
        {
            // Set;
            User *user = event.user;
            User *target = event.target;
            
            // Text;
            text = [NSString stringWithFormat:@"%@ is now friends with %@", user.username, target.username];
            break;
        }
            
        case 3:     // Joined;
        {
            // Set;
            User *user = event.user;
            
            // Text;
            text = [NSString stringWithFormat:@"%@ aka %@ joined Warbl! Friend then now!", user.name, user.username];
            break;
        }
            
        default:
            break;
    }
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue-Bold" size:14.0f]};
    CGRect rect = [text boundingRectWithSize:CGSizeMake(232.0f, 999.0f) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:	nil];
    CGFloat height = rect.size.height;
    
    return height < 50.0f ? 61.0f : height + 15.0f;
}

#pragma mark - NotificationCell
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
    
    lblForNotification.delegate = self;
    lblForNotification.linkAttributes = linkAttributes;
    lblForNotification.activeLinkAttributes = activeLinkAttributes;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

- (void)setNotification:(Event *)notification
{
    // Set;
    _notification = notification;
    
    // UI;
    switch (self.notification.action) {
        case 0:     // Posted;
        {
            // Set;
            User *user = self.notification.user;
            Video *target = self.notification.target;
            NSString *text = [NSString stringWithFormat:@"%@ posted %@", user.username, target.title];
            
            // Avatar;
            [btnForAvatar setImageWithURL:[NSURL URLWithString:user.avatar] forState:UIControlStateNormal];
            
            // Comment;
            NSRange userRange = NSMakeRange(0, user.username.length);
//          NSRange targetRange = NSMakeRange(text.length - target.title.length, target.title.length);
            
            [lblForNotification setText:text afterInheritingLabelAttributesAndConfiguringWithBlock:^NSMutableAttributedString *(NSMutableAttributedString *mutableAttributedString) {
                UIFont *boldFont = [UIFont fontWithName:@"HelveticaNeue-Bold" size:14.0f];
                
                if (boldFont) {
                    // User;
                    [mutableAttributedString addAttribute:(NSString *)kCTFontAttributeName value:boldFont range:userRange];
                    [mutableAttributedString addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)[UIColor blackColor].CGColor range:userRange];
                    
                    // Target;
//                  [mutableAttributedString addAttribute:(NSString *)kCTFontAttributeName value:boldFont range:targetRange];
//                  [mutableAttributedString addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)[UIColor blackColor].CGColor range:targetRange];
                }
                
                return mutableAttributedString;
            }];
            
            [lblForNotification addLinkToURL:[NSURL URLWithString:@"user"] withRange:userRange];
//          [lblForNotification addLinkToURL:[NSURL URLWithString:@"target"] withRange:targetRange];
            break;
        }
            
        case 1:     // Favorited;
        {
            // Set;
            User *user = self.notification.user;
            Video *target = self.notification.target;
            NSString *text = [NSString stringWithFormat:@"%@ favorited %@", user.username, target.title];
            
            // Avatar;
            [btnForAvatar setImageWithURL:[NSURL URLWithString:user.avatar] forState:UIControlStateNormal];

            // Comment;
            NSRange userRange = NSMakeRange(0, user.username.length);
//          NSRange targetRange = NSMakeRange(text.length - target.title.length, target.title.length);
            
            [lblForNotification setText:text afterInheritingLabelAttributesAndConfiguringWithBlock:^NSMutableAttributedString *(NSMutableAttributedString *mutableAttributedString) {
                UIFont *boldFont = [UIFont fontWithName:@"HelveticaNeue-Bold" size:14.0f];
                
                if (boldFont) {
                    // User;
                    [mutableAttributedString addAttribute:(NSString *)kCTFontAttributeName value:boldFont range:userRange];
                    [mutableAttributedString addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)[UIColor blackColor].CGColor range:userRange];
                    
                    // Target;
//                  [mutableAttributedString addAttribute:(NSString *)kCTFontAttributeName value:boldFont range:targetRange];
//                  [mutableAttributedString addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)[UIColor blackColor].CGColor range:targetRange];
                }
                
                return mutableAttributedString;
            }];
            
            [lblForNotification addLinkToURL:[NSURL URLWithString:@"user"] withRange:userRange];
//          [lblForNotification addLinkToURL:[NSURL URLWithString:@"target"] withRange:targetRange];
            break;
        }
            
        case 2:     // Followed;
        {
            // Set;
            User *user = self.notification.user;
            User *target = self.notification.target;
            NSString *text = [NSString stringWithFormat:@"%@ is now friends with %@", user.username, target.username];
            
            // Avatar;
            [btnForAvatar setImageWithURL:[NSURL URLWithString:user.avatar] forState:UIControlStateNormal];

            // Comment;
            NSRange userRange = NSMakeRange(0, user.username.length);
            NSRange targetRange = NSMakeRange(text.length - target.username.length, target.username.length);

            [lblForNotification setText:text afterInheritingLabelAttributesAndConfiguringWithBlock:^NSMutableAttributedString *(NSMutableAttributedString *mutableAttributedString) {
                UIFont *boldFont = [UIFont fontWithName:@"HelveticaNeue-Bold" size:14.0f];
                
                if (boldFont) {
                    // User;
                    [mutableAttributedString addAttribute:(NSString *)kCTFontAttributeName value:boldFont range:userRange];
                    [mutableAttributedString addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)[UIColor blackColor].CGColor range:userRange];
                    
                    // Target;
                    [mutableAttributedString addAttribute:(NSString *)kCTFontAttributeName value:boldFont range:targetRange];
                    [mutableAttributedString addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)[UIColor blackColor].CGColor range:targetRange];
                }
                
                return mutableAttributedString;
            }];
            
            [lblForNotification addLinkToURL:[NSURL URLWithString:@"user"] withRange:userRange];
            [lblForNotification addLinkToURL:[NSURL URLWithString:@"target"] withRange:targetRange];
            break;
        }
            
        case 3:     // Joined;
        {
            // Set;
            User *user = self.notification.user;
            NSString *text = [NSString stringWithFormat:@"%@ aka %@ joined Warbl! Friend then now!", user.name, user.username];
            
            // Avatar;
            [btnForAvatar setImageWithURL:[NSURL URLWithString:user.avatar] forState:UIControlStateNormal];

            // Comment;
            NSRange nameRange = NSMakeRange(0, user.name.length);
            NSRange usernameRange = NSMakeRange(user.name.length + 5, user.username.length);
            
            [lblForNotification setText:text afterInheritingLabelAttributesAndConfiguringWithBlock:^NSMutableAttributedString *(NSMutableAttributedString *mutableAttributedString) {
                UIFont *boldFont = [UIFont fontWithName:@"HelveticaNeue-Bold" size:14.0f];
                
                if (boldFont) {
                    // Name;
                    [mutableAttributedString addAttribute:(NSString *)kCTFontAttributeName value:boldFont range:nameRange];
                    [mutableAttributedString addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)[UIColor blackColor].CGColor range:nameRange];
                    
                    // Username;
                    [mutableAttributedString addAttribute:(NSString *)kCTFontAttributeName value:boldFont range:usernameRange];
                    [mutableAttributedString addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)[UIColor blackColor].CGColor range:usernameRange];
                }
                
                return mutableAttributedString;
            }];
            
            [lblForNotification addLinkToURL:[NSURL URLWithString:@"user"] withRange:nameRange];
            [lblForNotification addLinkToURL:[NSURL URLWithString:@"user"] withRange:usernameRange];
            break;
        }
            
        default:
            break;
    }
}

#pragma mark - TTTAttributedLabelDelegate
- (void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithURL:(NSURL *)url
{
    if ([url.absoluteString isEqualToString:@"user"]) {
        if ([self.delegate respondsToSelector:@selector(didUser:)]) {
            [self.delegate performSelector:@selector(didUser:) withObject:self.notification.user];
        }
    } else if ([url.absoluteString isEqualToString:@"target"]) {
        if ([self.delegate respondsToSelector:@selector(didUser:)]) {
            [self.delegate performSelector:@selector(didUser:) withObject:self.notification.target];
        }
    }
}

#pragma mark - Events
- (IBAction)onBtnAvatar:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(didUser:)]) {
        [self.delegate performSelector:@selector(didUser:) withObject:self.notification.user];
    }
}

@end
