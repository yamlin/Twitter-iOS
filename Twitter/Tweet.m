//
//  Tweet.m
//  Twitter
//
//  Created by Jhih-Yan Lin on 6/27/15.
//  Copyright (c) 2015 Jhih-Yan Lin. All rights reserved.
//

#import "Tweet.h"

@implementation Tweet

- (Tweet *)initWithDictionary:(NSDictionary *)dict {
    self = [super init];
    
    if (self) {
        self.user = [[User alloc] initWithDictionary:dict[@"user"]];
        self.text = dict[@"text"];
        self.retweet = dict[@"retweeted"];
        self.favorite = dict[@"favorited"];
        self.tweedId = dict[@"id_str"];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"EEE MMM d HH:mm:ss Z y";
        self.createdDate = [formatter dateFromString:dict[@"created_at"]];
    }
    
    return self;
}

+ (NSArray *)tweetsWithArray:(NSArray *)array {
    NSMutableArray *tweets = [NSMutableArray array];
    //NSLog(@"%@", array[0]);
    
    for (NSDictionary *dict in array) {
        [tweets addObject:[[Tweet alloc] initWithDictionary:dict]];
    }
    
    return tweets;
}

@end
