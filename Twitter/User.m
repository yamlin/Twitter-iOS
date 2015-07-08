//
//  User.m
//  Twitter
//
//  Created by Jhih-Yan Lin on 6/27/15.
//  Copyright (c) 2015 Jhih-Yan Lin. All rights reserved.
//

#import "User.h"
#import "TwitterClient.h"


NSString * const UserLoginNotification = @"UserLoginNotification";
NSString * const UserLogoutNotification = @"UserLogoutNotification";


@interface User()

@property (strong, nonatomic) NSDictionary *dictionary;

@end

@implementation User

- (id) initWithDictionary:(NSDictionary *) dict {
    
    self = [super init];
    
    if (self) {
        self.dictionary = dict;
        self.name = dict[@"name"];
        self.screenName = dict[@"screen_name"];
        self.profileImageUrl = dict[@"profile_image_url"];
        self.tagLine = dict[@"description"];
        self.uid = dict[@"id_str"];
    }
    
    return self;
}

// Store the user information
static User *_currentUser = nil;
NSString * const kCurrentUser = @"kCurrentUserKey";

+ (User *)getUser {
    if (_currentUser == nil) {
        NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:kCurrentUser];
        if (data != nil) {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
            _currentUser = [[User alloc] initWithDictionary:dict];
        }
    }
    return _currentUser;
}

+ (void) setUser:(User *) user {
    _currentUser = user;
    
    if (_currentUser != nil) {
        NSData *data = [NSJSONSerialization dataWithJSONObject:user.dictionary options:0 error:NULL];
        [[NSUserDefaults standardUserDefaults] setObject:data forKey:kCurrentUser];
    } else {
        [[NSUserDefaults standardUserDefaults] setObject:nil forKey:kCurrentUser];
    }
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (void) logout {
    // user logout
    [User setUser:nil];
    
    [[TwitterClient sharedInstance].requestSerializer removeAccessToken];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:UserLogoutNotification object:nil];
}

@end
