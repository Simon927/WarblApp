//
//  APIClient.h
//  Warbl
//
//  Created by Xin ZhangZhe on 4/3/14.
//  Copyright (c) 2014 sptmbr LLC. All rights reserved.
//
// --- Headers ---;
#if __IPHONE_OS_VERSION_MIN_REQUIRED
#import "AFHTTPRequestOperationManager.h"
#else
#import "AFHTTPSessionManager.h"
#endif

#import "Account.h"

// --- Classes --- ;
@class Account;
@class User;
@class Video;

// --- Defines ---;
// APIClient Class;
#if __IPHONE_OS_VERSION_MIN_REQUIRED
@interface APIClient : AFHTTPRequestOperationManager
#else
@interface APIClient : AFHTTPSessionManager
#endif

// Sign;
+ (void)signInFacebookWithUsername:(NSString *)username name:(NSString *)name email:(NSString *)email facebookId:(NSString *)facebookId friends:(NSArray *)friends completion:(void (^)(Account *account, AccountMessage message))completion;
+ (void)signInWithUsername:(NSString *)username password:(NSString *)password completion:(void (^)(Account *account, AccountMessage message))completion;
+ (void)signUpWithAvatar:(UIImage *)avatar username:(NSString *)username password:(NSString *)password email:(NSString *)email completion:(void (^)(Account *account, AccountMessage message))completion;
+ (void)forgotPasswordForEmail:(NSString *)email completion:(void (^)(BOOL successed))completion;

// Profile;
+ (void)saveProfileWithAvatar:(UIImage *)avatar username:(NSString *)username name:(NSString *)name email:(NSString *)email password:(NSString *)password completion:(void (^)(AccountMessage message))completion;

// Posts;
+ (void)getFeedReposts:(NSInteger)last count:(NSInteger)count completion:(void (^)(NSArray *posts))completion;
+ (void)getFeaturedReposts:(NSInteger)last count:(NSInteger)count completion:(void (^)(NSArray *posts))completion;
+ (void)getReposts:(NSInteger)last count:(NSInteger)count completion:(void (^)(NSArray *posts))completion;
+ (void)getFavorites:(NSInteger)last count:(NSInteger)count completion:(void (^)(NSArray *posts))completion;
+ (void)getFollows:(NSInteger)last count:(NSInteger)count completion:(void (^)(NSArray *follows))completion;
+ (void)getFacebookFriends:(NSInteger)last count:(NSInteger)count completion:(void (^)(NSArray *follows))completion;

+ (void)getUserReposts:(User *)user last:(NSInteger)last count:(NSInteger)count completion:(void (^)(NSArray *posts))completion;
+ (void)getUserFavorites:(User *)user last:(NSInteger)last count:(NSInteger)count completion:(void (^)(NSArray *posts))completion;

+ (void)getNotifications:(NSInteger)last count:(NSInteger)count completion:(void (^)(NSArray *notifications))completion;


+ (void)repostVideo:(Video *)video completion:(void (^)(BOOL finished))completion;
+ (void)deleteVideo:(Video *)video completion:(void (^)(BOOL finished))completion;

// Favorites;
+ (void)favoriteVideo:(Video *)video completion:(void (^)(BOOL finished))completion;
+ (void)unfavoriteVideo:(Video *)video completion:(void (^)(BOOL finished))completion;

// Follows;
+ (void)followUser:(User *)user completion:(void (^)(BOOL finished))completion;
+ (void)unfollowUser:(User *)user completion:(void (^)(BOOL finished))completion;
+ (void)searchFriends:(NSString *)text number:(NSInteger)number count:(NSInteger)count completion:(void (^)(NSArray *follows))completion;

@end
