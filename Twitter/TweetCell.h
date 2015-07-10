//
//  TweetCell.h
//  Twitter
//
//  Created by Jhih-Yan Lin on 6/28/15.
//  Copyright (c) 2015 Jhih-Yan Lin. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Tweet.h"

@class TweetCell;

@protocol TweetCellDelegate<NSObject>

- (void)replyTweet:(Tweet *) tweet;
- (void)onProfile:(User *) user;

@end

@interface TweetCell : UITableViewCell
- (void) setTweet:(Tweet *)tweet;

@property (weak, nonatomic) id<TweetCellDelegate> delegate;

@end
