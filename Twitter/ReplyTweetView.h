//
//  ReplyTweetView.h
//  Twitter
//
//  Created by Jhih-Yan Lin on 6/30/15.
//  Copyright (c) 2015 Jhih-Yan Lin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tweet.h"
@class ReplyTweetView;

@protocol ReplyTweetViewDelegate <NSObject>

- (void)onReply:(NSString *)replyText withTweet:(Tweet *)tweet;


@end

@interface ReplyTweetView : UIViewController

@property(weak, nonatomic) id<ReplyTweetViewDelegate> delegate;
@property(strong, nonatomic) Tweet* tweet;

@end
