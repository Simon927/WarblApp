//
//  User.m
//  Warbl
//
//  Created by Xin ZhangZhe on 4/3/14.
//  Copyright (c) 2014 sptmbr LLC. All rights reserved.
//
// --- Headers ---;
#import "Account.h"

// --- Defines ---;
// Account Class;
@implementation Account

// Functions;
#pragma mark - Shared Functions
+ (instancetype)me
{
    static Account *_me;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        _me = [[Account alloc] init];
    });
    
    return _me;
}

+ (void)signOut
{
    
}

+ (void)forgotPasswordForEmail:(NSString *)email completion:(void (^)(void))completion
{
    
}

#pragma mark - Account
- (instancetype)initWithAttributes:(NSDictionary *)attributes
{
    self = [super init];
    if (self) {
        // Set;
        [self setAttributes:attributes];
    }
    
    return self;
}

- (void)dealloc
{

}

#pragma mark - Authenticated
- (BOOL)isAuthenticated
{
    return [self objectId] > 0;
}

- (void)logout
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"userid"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"username"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"name"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"email"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"quality"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"posts"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"favorites"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"follows"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"created_at"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark - Get
- (NSString *)objectId
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"userid"];
}

- (NSString *)username
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"username"];
}

- (NSString *)name
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"name"];
}

- (NSString *)email
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"email"];
}

- (NSString *)avatar
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"avatar"];
}

- (NSInteger)quality
{
    return [[NSUserDefaults standardUserDefaults] integerForKey:@"quality"];
}

- (NSInteger)posts
{
    return [[NSUserDefaults standardUserDefaults] integerForKey:@"posts"];
}

- (NSInteger)favorites
{
    return [[NSUserDefaults standardUserDefaults] integerForKey:@"favorites"];
}

- (NSInteger)follows
{
    return [[NSUserDefaults standardUserDefaults] integerForKey:@"follows"];
}

- (NSInteger)createAt
{
    return [[NSUserDefaults standardUserDefaults] integerForKey:@"created_at"];
}

#pragma mark - Set
- (void)setObject:(NSObject *)object forKey:(NSString *)key
{
    [[NSUserDefaults standardUserDefaults] setObject:object forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)setInteger:(NSInteger)value forKey:(NSString *)key
{
    [[NSUserDefaults standardUserDefaults] setInteger:value forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)setObjectId:(NSString *)objectId
{
    [self setObject:objectId forKey:@"userid"];
}

- (void)setUsername:(NSString *)username
{
    [self setObject:username forKey:@"username"];
}

- (void)setName:(NSString *)name
{
    [self setObject:name forKey:@"name"];
}

- (void)setEmail:(NSString *)email
{
    [self setObject:email forKey:@"email"];
}

- (void)setAvatar:(NSString *)avatar
{
    [self setObject:avatar forKey:@"avatar"];
}

- (void)setQuality:(NSInteger)quality
{
    [self setInteger:quality forKey:@"quality"];
}

- (void)setPosts:(NSInteger)posts
{
    [self setInteger:posts forKey:@"posts"];
}

- (void)setFavorites:(NSInteger)favorites
{
    [self setInteger:favorites forKey:@"favorites"];
}

- (void)setFollows:(NSInteger)follows
{
    [self setInteger:follows forKey:@"follows"];
}

- (void)setCreateAt:(NSInteger)createAt
{
    [self setInteger:createAt forKey:@"created_at"];
}

- (void)setAttributes:(NSDictionary *)attributes
{
    [self setObjectId:attributes[@"userid"]];
    [self setUsername:attributes[@"username"]];
    [self setName:attributes[@"name"]];
    [self setEmail:attributes[@"email"]];
    [self setAvatar:attributes[@"avatar"]];
    [self setQuality:[attributes[@"quality"] integerValue]];
    [self setPosts:[attributes[@"posts"] integerValue]];
    [self setFavorites:[attributes[@"favorites"] integerValue]];
    [self setFollows:[attributes[@"follows"] integerValue]];
    [self setCreateAt:[attributes[@"created_at"] integerValue]];
}

@end
