//
//  Tweet.h
//  Twitter
//
//  Created by Jhih-Yan Lin on 6/27/15.
//  Copyright (c) 2015 Jhih-Yan Lin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"
@interface Tweet : NSObject

@property (strong, nonatomic) NSString *text;
@property (strong, nonatomic) NSDate *createdDate;
@property (strong, nonatomic) User *user;
@property (strong, nonatomic) NSString *favorite;
@property (strong, nonatomic) NSString *retweet;

@property (strong, nonatomic) NSString *tweedId;

+ (NSArray *)tweetsWithArray:(NSArray *)array;
@end
