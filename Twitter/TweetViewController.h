//
//  TweetViewController.h
//  Twitter
//
//  Created by Jhih-Yan Lin on 6/28/15.
//  Copyright (c) 2015 Jhih-Yan Lin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"
#import "Tweet.h"

@class TweetViewController;


@protocol TweetViewDelegate <NSObject>

- (void)getUserProfile:(User *) user;

- (void)showReplyView:(Tweet *)tweet;

- (void)postTweet:(NSDictionary *)params;

@end

@interface TweetViewController : UIViewController

@property(strong, nonatomic) NSArray *tweets;

@property(strong, nonatomic) id<TweetViewDelegate> delegate;
@end
