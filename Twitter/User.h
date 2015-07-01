//
//  User.h
//  Twitter
//
//  Created by Jhih-Yan Lin on 6/27/15.
//  Copyright (c) 2015 Jhih-Yan Lin. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const UserLoginNotification;
extern NSString * const UserLogoutNotification;

@interface User : NSObject
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *screenName;
@property (strong, nonatomic) NSString *profileImageUrl;
@property (strong, nonatomic) NSString *tagLine;


- (User *)initWithDictionary:(NSDictionary *) dict;


+ (User *)getUser;
+ (void) setUser:(User *) user;
+ (void) logout;
    
@end
