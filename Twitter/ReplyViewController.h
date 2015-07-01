//
//  ReplyViewController.h
//  Twitter
//
//  Created by Jhih-Yan Lin on 6/29/15.
//  Copyright (c) 2015 Jhih-Yan Lin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tweet.h"

@class ReplyViewController;

@protocol ReplyViewControllerDelegate <NSObject>

- (void)onReply:(Tweet *) tweet completion:(void (^)(NSString *text, NSError *error)) completion;


@end

@interface ReplyViewController : UIViewController

@property (strong, nonatomic) Tweet *tweet;

@property (weak, nonatomic) id<ReplyViewControllerDelegate> delegate;
@end
