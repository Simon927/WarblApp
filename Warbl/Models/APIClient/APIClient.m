//
//  APIClient.m
//  Warbl
//
//  Created by Xin ZhangZhe on 4/3/14.
//  Copyright (c) 2014 sptmbr LLC. All rights reserved.
//
// --- Headers ---;
#import "APIClient.h"

#import "Account.h"
#import "User.h"
#import "Video.h"
#import "Event.h"

// --- Defines ---;
// APIBase URL;
static NSString * const kAPIBaseURLString = @"http://warbl.hongjisoft.com";

// APIClient Class;
@implementation APIClient

// Functions;
#pragma mark - Shared Client
+ (instancetype)sharedClient
{
    static APIClient *_sharedClient;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        _sharedClient = [[APIClient alloc] initWithBaseURL:[NSURL URLWithString:kAPIBaseURLString]];
        
        // Set;
        _sharedClient.responseSerializer = [AFJSONResponseSerializer serializer];
        _sharedClient.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    });
    
    return _sharedClient;
}

#pragma mark - APIClient
- (void)GET:(NSString *)url parameters:(NSDictionary *)parameters completion:(void (^)(id responseObject, NSError *error))completion
{
#if __IPHONE_OS_VERSION_MIN_REQUIRED
    [self GET:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (completion) {
            completion(responseObject, nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (completion) {
            completion(nil, error);
        }
    }];
#else
    [self GET:url parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        if (completion) {
            completion(responseObject, nil);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (completion) {
            completion(nil, error);
        }
    }];
#endif
}

- (void)POST:(NSString *)url parameters:(NSDictionary *)parameters completion:(void (^)(id responseObject, NSError *error))completion
{
#if __IPHONE_OS_VERSION_MIN_REQUIRED
    [self POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (completion) {
            completion(responseObject, nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (completion) {
            completion(nil, error);
        }
    }];
#else
    [self POST:url parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        if (completion) {
            completion(responseObject, nil);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (completion) {
            completion(nil, error);
        }
    }];
#endif
}

- (void)POST:(NSString *)url parameters:(NSDictionary *)parameters constructing:(void (^)(id <AFMultipartFormData> formData))block completion:(void (^)(id responseObject, NSError *error))completion
{
#if __IPHONE_OS_VERSION_MIN_REQUIRED
        [self POST:url parameters:parameters constructingBodyWithBlock:block success:^(AFHTTPRequestOperation *operation, id responseObject) {
            if (completion) {
                completion(responseObject, nil);
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            if (completion) {
                completion(nil, error);
            }
        }];
#else
        [self POST:url parameters:parameters constructingBodyWithBlock:block success:^(NSURLSessionDataTask *task, id responseObject) {
            if (completion) {
                completion(responseObject, nil);
            }
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            NSLog(@"%@", task.currentRequest.allHTTPHeaderFields);
            
            if (completion) {
                completion(nil, error);
            }
        }];
#endif
}

#pragma mark - Sign
+ (void)signInFacebookWithUsername:(NSString *)username name:(NSString *)name email:(NSString *)email facebookId:(NSString *)facebookId friends:(NSArray *)friends completion:(void (^)(Account *account, AccountMessage message))completion
{
    // Params;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    params[@"action"] = @"signinfacebook";
    params[@"username"] = username;
    params[@"name"] = name;
    params[@"email"] = email;
    params[@"facebookid"] = facebookId;
    params[@"friends"] = friends;
    
    // POST;
    [[APIClient sharedClient] POST:@"index.php" parameters:params completion:^(id responseObject, NSError *error) {
        AccountMessage message;
        
        if (error) {
            message = AccountMessageInvalidConnection;
        } else if ([responseObject[@"result"] isEqualToString:@"successed"]) {
            message = AccountMessageSuccessed;
            
            // Set;
            [[Account me] setAttributes:responseObject[@"user"]];
        } else {
            message = AccountMessageInvaildUserInfo;
        }
        
        if (completion) {
            completion([Account me], message);
        }
    }];
}

+ (void)signInWithUsername:(NSString *)username password:(NSString *)password completion:(void (^)(Account *account, AccountMessage message))completion
{
    // Params;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    params[@"action"] = @"signin";
    params[@"username"] = username;
    params[@"password"] = password;
    
    // GET;
    [[APIClient sharedClient] GET:@"index.php" parameters:params completion:^(id responseObject, NSError *error) {
        AccountMessage message;
        
        if (error) {
            message = AccountMessageInvalidConnection;
        } else if ([responseObject[@"result"] isEqualToString:@"successed"]) {
            message = AccountMessageSuccessed;
            
            // Set;
            [[Account me] setAttributes:responseObject[@"user"]];
        } else {
            message = AccountMessageInvaildUserInfo;
        }
        
        if (completion) {
            completion([Account me], message);
        }
    }];
}

+ (void)signUpWithAvatar:(UIImage *)avatar username:(NSString *)username password:(NSString *)password email:(NSString *)email completion:(void (^)(Account *account, AccountMessage message))completion;
{
    // Params;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    params[@"action"] = @"signup";
    params[@"username"] = username;
    params[@"password"] = password;
    params[@"email"] = email;
    
    // POST;
    [[APIClient sharedClient] POST:@"index.php" parameters:params constructing:^(id<AFMultipartFormData> formData) {
        if (avatar) {
            // Avatar;
            NSData *data = UIImageJPEGRepresentation(avatar, 0.5f);
            
            // Append;
            [formData appendPartWithFileData:data name:@"avatar" fileName:@"avatar.jpg" mimeType:@"image/jpeg"];
        }
    } completion:^(id responseObject, NSError *error) {
        AccountMessage message;
        
        if (error) {
            message = AccountMessageInvalidConnection;
        } else if ([responseObject[@"result"] isEqualToString:@"successed"]) {
            message = AccountMessageSuccessed;
            
            // Set;
            [[Account me] setAttributes:responseObject[@"user"]];
        } else if ([responseObject[@"message"] isEqualToString:@"Invalid Username"]) {
            message = AccountMessageInvalidUsername;
        } else if ([responseObject[@"message"] isEqualToString:@"Invalid Email"]) {
            message = AccountMessageInvalidEmail;
        } else {
            message = AccountMessageInvaildUserInfo;
        }
        
        if (completion) {
            completion([Account me], message);
        }
    }];
}

+ (void)forgotPasswordForEmail:(NSString *)email completion:(void (^)(BOOL successed))completion
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    params[@"action"] = @"forgotpassword";
    params[@"email"] = email;

    // POST;
    [[self sharedClient] POST:@"index.php" parameters:params completion:^(id responseObject, NSError *error) {
        if (completion) {
            completion(!error);
        }
    }];
}

#pragma mark - Profile
+ (void)saveProfileWithAvatar:(UIImage *)avatar username:(NSString *)username name:(NSString *)name email:(NSString *)email password:(NSString *)password completion:(void (^)(AccountMessage message))completion
{
    // Params;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    params[@"action"] = @"saveprofile";
    params[@"account"] = [Account me].objectId;
    params[@"username"] = username;
    params[@"password"] = password;
    params[@"name"] = name;
    params[@"email"] = email;
    
    // POST;
    [[self sharedClient] POST:@"index.php" parameters:params constructing:^(id<AFMultipartFormData> formData) {
        if (avatar) {
            // Avatar;
            NSData *data = UIImageJPEGRepresentation(avatar, 0.5f);
            
            // Append;
            [formData appendPartWithFileData:data name:@"avatar" fileName:@"avatar.jpg" mimeType:@"image/jpeg"];
        }
    } completion:^(id responseObject, NSError *error) {
        AccountMessage message;
        
        if (error) {
            message = AccountMessageInvalidConnection;
        } else if ([responseObject[@"result"] isEqualToString:@"successed"]) {
            message = AccountMessageSuccessed;
            
            // Set;
            [[Account me] setAttributes:responseObject[@"user"]];
        } else {
            message = AccountMessageInvaildUserInfo;
        }
        
        if (completion) {
            completion(message);
        }
    }];
}

#pragma mark - Posts
+ (void)getFeedReposts:(NSInteger)last count:(NSInteger)count completion:(void (^)(NSArray *posts))completion
{
    // Params;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    params[@"action"] = @"getfeedposts";
    params[@"account"] = [Account me].objectId;
    params[@"last"] = [NSNumber numberWithInteger:last];
    params[@"count"] = [NSNumber numberWithInteger:count];
    
    // POST;
    [[self sharedClient] POST:@"index.php" parameters:params completion:^(id responseObject, NSError *error) {
        NSMutableArray *posts = [NSMutableArray array];
        
        for (NSDictionary *item in responseObject) {
            Event *event = [[Event alloc] initWithAttributes:item];
            
            // Add;
            [posts addObject:event];
        }
        
        if (completion) {
            completion(posts);
        }
    }];
}

+ (void)getFeaturedReposts:(NSInteger)last count:(NSInteger)count completion:(void (^)(NSArray *posts))completion
{
    // Params;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    params[@"action"] = @"getfeaturedposts";
    params[@"account"] = [Account me].objectId ? [Account me].objectId : @"";
    params[@"last"] = [NSNumber numberWithInteger:last];
    params[@"count"] = [NSNumber numberWithInteger:count];
    
    // POST;
    [[self sharedClient] POST:@"index.php" parameters:params completion:^(id responseObject, NSError *error) {
        NSMutableArray *posts = [NSMutableArray array];
        
        for (NSDictionary *item in responseObject) {
            Video *video = [[Video alloc] initWithAttributes:item];
            
            // Add;
            [posts addObject:video];
        }
        
        if (completion) {
            completion(posts);
        }
    }];
}

+ (void)getReposts:(NSInteger)last count:(NSInteger)count completion:(void (^)(NSArray *posts))completion
{
    // Params;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    params[@"action"] = @"getreposts";
    params[@"account"] = [Account me].objectId;
    params[@"last"] = [NSNumber numberWithInteger:last];
    params[@"count"] = [NSNumber numberWithInteger:count];
    
    // POST;
    [[self sharedClient] POST:@"index.php" parameters:params completion:^(id responseObject, NSError *error) {
        NSMutableArray *posts = [NSMutableArray array];
        
        for (NSDictionary *item in responseObject) {
            Video *video = [[Video alloc] initWithAttributes:item];
            
            // Add;
            [posts addObject:video];
        }
        
        if (completion) {
            completion(posts);
        }
    }];
}

+ (void)getFavorites:(NSInteger)last count:(NSInteger)count completion:(void (^)(NSArray *posts))completion
{
    // Params;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    params[@"action"] = @"getfavorites";
    params[@"account"] = [Account me].objectId;
    params[@"last"] = [NSNumber numberWithInteger:last];
    params[@"count"] = [NSNumber numberWithInteger:count];
    
    // POST;
    [[self sharedClient] POST:@"index.php" parameters:params completion:^(id responseObject, NSError *error) {
        NSMutableArray *posts = [NSMutableArray array];
        
        for (NSDictionary *item in responseObject) {
            Video *video = [[Video alloc] initWithAttributes:item];
            
            // Add;
            [posts addObject:video];
        }
        
        if (completion) {
            completion(posts);
        }
    }];
}

+ (void)getFollows:(NSInteger)last count:(NSInteger)count completion:(void (^)(NSArray *follows))completion
{
    // Params;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    params[@"action"] = @"getfollows";
    params[@"account"] = [Account me].objectId;
    params[@"last"] = [NSNumber numberWithInteger:last];
    params[@"count"] = [NSNumber numberWithInteger:count];
    
    // POST;
    [[self sharedClient] POST:@"index.php" parameters:params completion:^(id responseObject, NSError *error) {
        NSMutableArray *follows = [NSMutableArray array];
        
        if (!error) {
            for (NSDictionary *item in responseObject) {
                User *follow = [[User alloc] initWithAttributes:item];
                
                // Add;
                [follows addObject:follow];
            }
        }
        
        if (completion) {
            completion(follows);
        }
    }];
}

+ (void)getFacebookFriends:(NSInteger)last count:(NSInteger)count completion:(void (^)(NSArray *follows))completion
{
    // Params;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    params[@"action"] = @"getfacebookfriends";
    params[@"account"] = [Account me].objectId;
    params[@"last"] = [NSNumber numberWithInteger:last];
    params[@"count"] = [NSNumber numberWithInteger:count];
    
    // POST;
    [[self sharedClient] POST:@"index.php" parameters:params completion:^(id responseObject, NSError *error) {
        NSMutableArray *follows = [NSMutableArray array];
        
        if (!error) {
            for (NSDictionary *item in responseObject) {
                User *follow = [[User alloc] initWithAttributes:item];
                
                // Add;
                [follows addObject:follow];
            }
        }
        
        if (completion) {
            completion(follows);
        }
    }];
}

+ (void)getUserReposts:(User *)user last:(NSInteger)last count:(NSInteger)count completion:(void (^)(NSArray *posts))completion
{
    // Params;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    params[@"action"] = @"getuserreposts";
    params[@"account"] = [Account me].objectId;
    params[@"userid"] = [NSNumber numberWithInteger:user.userId];
    params[@"last"] = [NSNumber numberWithInteger:last];
    params[@"count"] = [NSNumber numberWithInteger:count];
    
    // POST;
    [[self sharedClient] POST:@"index.php" parameters:params completion:^(id responseObject, NSError *error) {
        NSMutableArray *posts = [NSMutableArray array];
        
        for (NSDictionary *item in responseObject) {
            Video *video = [[Video alloc] initWithAttributes:item];
            
            // Add;
            [posts addObject:video];
        }
        
        if (completion) {
            completion(posts);
        }
    }];
}

+ (void)getUserFavorites:(User *)user last:(NSInteger)last count:(NSInteger)count completion:(void (^)(NSArray *posts))completion
{
    // Params;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    params[@"action"] = @"getuserfavorites";
    params[@"account"] = [Account me].objectId;
    params[@"userid"] = [NSNumber numberWithInteger:user.userId];
    params[@"last"] = [NSNumber numberWithInteger:last];
    params[@"count"] = [NSNumber numberWithInteger:count];
    
    // POST;
    [[self sharedClient] POST:@"index.php" parameters:params completion:^(id responseObject, NSError *error) {
        NSMutableArray *posts = [NSMutableArray array];
        
        for (NSDictionary *item in responseObject) {
            Video *video = [[Video alloc] initWithAttributes:item];
            
            // Add;
            [posts addObject:video];
        }
        
        if (completion) {
            completion(posts);
        }
    }];
}


#pragma mark - Notifications
+ (void)getNotifications:(NSInteger)last count:(NSInteger)count completion:(void (^)(NSArray *notifications))completion
{
    // Params;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    params[@"action"] = @"getnotifications";
    params[@"account"] = [Account me].objectId;
    params[@"last"] = [NSNumber numberWithInteger:last];
    params[@"count"] = [NSNumber numberWithInteger:count];
    
    // POST;
    [[self sharedClient] POST:@"index.php" parameters:params completion:^(id responseObject, NSError *error) {
        NSMutableArray *notifications = [NSMutableArray array];
        
        if (!error) {
            for (NSDictionary *item in responseObject) {
                Event *event = [[Event alloc] initWithAttributes:item];
                
                // Add;
                [notifications addObject:event];
            }
        }
        
        if (completion) {
            completion(notifications);
        }
    }];
}

+ (void)repostVideo:(Video *)video completion:(void (^)(BOOL finished))completion
{
    // Params;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    params[@"action"] = @"repostvideo";
    params[@"account"] = [Account me].objectId;
    params[@"identifier"] = video.identifier;
    params[@"title"] = video.title;
    params[@"thumbnail"] = video.thumbnail;
    
    // Animating;
    video.posted = 2;
    
    // POST;
    [[self sharedClient] POST:@"index.php" parameters:params completion:^(id responseObject, NSError *error) {
        if (!error) {
            // Video;
            [video setAttributes:responseObject[@"video"]];
            
            // Account;
            [Account me].posts ++;
        }
        
        if (completion) {
            completion(!error);
        }
    }];
}

+ (void)deleteVideo:(Video *)video completion:(void (^)(BOOL finished))completion
{
    // Params;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    params[@"action"] = @"deletevideo";
    params[@"account"] = [Account me].objectId;
    params[@"videoid"] = [NSNumber numberWithInteger:video.videoId];
    
    // Animating;
    video.favorited = 2;
    
    // POST;
    [[self sharedClient] POST:@"index.php" parameters:params completion:^(id responseObject, NSError *error) {
        if (!error) {
            // Video;
            [video setAttributes:responseObject[@"video"]];
            
            // Account;
            [Account me].posts --;
        }
        
        if (completion) {
            completion(!error);
        }
    }];
}

#pragma mark - Favorites
+ (void)favoriteVideo:(Video *)video completion:(void (^)(BOOL finished))completion
{
    // Params;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    params[@"action"] = @"favoritevideo";
    params[@"account"] = [Account me].objectId;
    params[@"identifier"] = video.identifier;
    params[@"title"] = video.title;
    params[@"thumbnail"] = video.thumbnail;
    
    // Animating;
    video.favorited = 2;
    
    // POST;
    [[self sharedClient] POST:@"index.php" parameters:params completion:^(id responseObject, NSError *error) {
        if (!error) {
            // Video;
            [video setAttributes:responseObject[@"video"]];
            
            // Account;
            [Account me].favorites ++;
        }
        
        if (completion) {
            completion(!error);
        }
    }];
}

+ (void)unfavoriteVideo:(Video *)video completion:(void (^)(BOOL finished))completion
{
    // Params;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    params[@"action"] = @"unfavoritevideo";
    params[@"account"] = [Account me].objectId;
    params[@"videoid"] = [NSNumber numberWithInteger:video.videoId];
    
    // Animating;
    video.favorited = 2;
    
    // POST;
    [[self sharedClient] POST:@"index.php" parameters:params completion:^(id responseObject, NSError *error) {
        if (!error) {
            // Video;
            [video setAttributes:responseObject[@"video"]];
            
            // Account;
            [Account me].favorites --;
        }
        
        if (completion) {
            completion(!error);
        }
    }];
}

#pragma mark - Follows
+ (void)followUser:(User *)user completion:(void (^)(BOOL finished))completion
{
    // Params;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    params[@"action"] = @"followfriend";
    params[@"account"] = [Account me].objectId;
    params[@"userid"] = [ NSNumber numberWithInteger:user.userId];
    
    // Animating;
    user.followed = 2;
    
    // POST;
    [[self sharedClient] POST:@"index.php" parameters:params completion:^(id responseObject, NSError *error) {
        if (!error) {
            // User;
            user.followed = 1;
            
            // Account;
            [Account me].follows ++;
        }
        
        if (completion) {
            completion(!error);
        }
    }];
}

+ (void)unfollowUser:(User *)user completion:(void (^)(BOOL finished))completion
{
    // Params;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    params[@"action"] = @"unfollowfriend";
    params[@"account"] = [Account me].objectId;
    params[@"userid"] = [NSNumber numberWithInteger:user.userId];
    
    // Animating;
    user.followed = 2;
    
    // POST;
    [[self sharedClient] POST:@"index.php" parameters:params completion:^(id responseObject, NSError *error) {
        if (!error) {
            // User;
            user.followed = 0;
            
            // Account;
            [Account me].follows --;
        }
        
        if (completion) {
            completion(!error);
        }
    }];
}

+ (void)searchFriends:(NSString *)text number:(NSInteger)number count:(NSInteger)count completion:(void (^)(NSArray *follows))completion
{
    // Params;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    params[@"action"] = @"searchfriends";
    params[@"account"] = [Account me].objectId;
    params[@"text"] = text;
    params[@"number"] = [NSNumber numberWithInteger:number];
    params[@"count"] = [NSNumber numberWithInteger:count];
    
    // POST;
    [[self sharedClient] POST:@"index.php" parameters:params completion:^(id responseObject, NSError *error) {
        NSMutableArray *follows = [NSMutableArray array];
        
        if (!error) {
            for (NSDictionary *item in responseObject) {
                User *user = [[User alloc] initWithAttributes:item];
                
                // Add;
                [follows addObject:user];
            }
        }
        
        if (completion) {
            completion(follows);
        }
    }];
}

@end
