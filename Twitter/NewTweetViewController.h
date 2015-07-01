//
//  NewTweetViewController.h
//  Twitter
//
//  Created by Jhih-Yan Lin on 6/29/15.
//  Copyright (c) 2015 Jhih-Yan Lin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NewTweetViewController;

@protocol NewTweetViewControllerDelegate <NSObject>

- (void) postTweet:(NSDictionary *)params;

@end

@interface NewTweetViewController : UIViewController

@property (weak, nonatomic) id<NewTweetViewControllerDelegate> delegate;


@end
