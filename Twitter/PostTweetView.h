//
//  PostTweetView.h
//  Twitter
//
//  Created by Jhih-Yan Lin on 6/30/15.
//  Copyright (c) 2015 Jhih-Yan Lin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"


@class PostTweetView;

@protocol PostTweetViewDelegate <NSObject>

- (void) postTweet:(NSDictionary *)params;

@end

@interface PostTweetView : UIViewController

@property(weak, nonatomic) id<PostTweetViewDelegate> delegate;
@property(strong, nonatomic) User* user;

@end
